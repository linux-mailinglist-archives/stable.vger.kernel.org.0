Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BA358FA98
	for <lists+stable@lfdr.de>; Thu, 11 Aug 2022 12:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbiHKKT1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Aug 2022 06:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiHKKT0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Aug 2022 06:19:26 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B343D7C19C
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 03:19:24 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 12so16766891pga.1
        for <stable@vger.kernel.org>; Thu, 11 Aug 2022 03:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:subject:to:from
         :user-agent:mime-version:date:message-id:from:to:cc;
        bh=JHzjL++Up/zOW+L31I2zUj7vxEdQLwTwaTHj9BtGppk=;
        b=IuQQjwHcDCYH2lZLIqLic7y0acMv1N/NKnxyDnEYXIRsTppXgJwrJHeRnWnR3sdtHr
         yQYOIRs00I9N3t+6yJSGWV0DH5zJdhBIZ6Ern33Da1A33TfvV/uq1TXOacM+/mrVRCOe
         fU15ZZGkBkSsvpIKmhMxzWv5DZv7AUYUXFItiebQabVKEwoVfNNnpMNbw5nAK6QthyxN
         hhw2abdLkvAAvl3kTOnSOslAG5Rk8BJKGrSbLaTK41AyrBiCF5NOZ0wioayf5PNYs3Eu
         qQfXKdHLQyP3yfNjaU8CucdWAyIOVmfM6nJOvBqk82CTFORZYK/qcOiOeS8dLH7h8ssh
         5RWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:subject:to:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc;
        bh=JHzjL++Up/zOW+L31I2zUj7vxEdQLwTwaTHj9BtGppk=;
        b=6Qrygndg4kETHdgV5QTvPhc7K3twnE/Rj1OCPnaKJx1GhqQx7zwiCBZ734ytid/c5j
         IwligbbvSmLHVWD69rUik8YwmPYK+/Mb3MqOzcxzsYNVhBJ+6H+ns8XgrK5jKOjnFVl0
         IbfxpxGxHjao0NwkkFTDafl1ntPRMy5YV8OmJC9Qcn2F0mmJ8sYfEKkLIwEUA8RJS78b
         MciliBnzHlsxJ+baBRyzKomkxb11xjeWG7mLiLYSRp4oqKEbUzYIOaO4r749UZoU130O
         fBMHozzfqyjMcHAQCy8rWFCEAf+wO++M6v9k/8UfmW33WktJvvchwwbjbMpm5TEMAMmZ
         zoBA==
X-Gm-Message-State: ACgBeo10xVQzGiB/LWwZmICxG9ZkraboIKVpMbjg47n/7ZDwhSvitnJH
        LuPMgkRIInsLZGOFEI5anEs=
X-Google-Smtp-Source: AA6agR71ouV8phhKZJVkl3R3cx21WbDGvP7jEvkqzDOf6olu5TdmiBk8QLXj7KNN8Z5uK0BpUdVzZA==
X-Received: by 2002:a63:2cc6:0:b0:41c:5f9c:e15c with SMTP id s189-20020a632cc6000000b0041c5f9ce15cmr25847124pgs.241.1660213164156;
        Thu, 11 Aug 2022 03:19:24 -0700 (PDT)
Received: from [0.0.0.0] ([205.198.104.55])
        by smtp.gmail.com with ESMTPSA id p127-20020a622985000000b0052d98fbf8f3sm3654450pfp.56.2022.08.11.03.19.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 03:19:23 -0700 (PDT)
Message-ID: <1bb5e092-310b-26fa-38f7-fb797b1cd995@gmail.com>
Date:   Thu, 11 Aug 2022 18:19:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   meljbao@gmail.com
To:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sasha Neftin <sasha.neftin@intel.com>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH] igc: Remove _I_PHY_ID checking for i225 devices
References: <5d499487-2503-f1bd-586c-57ac755e1f41@gmail.com>
 <YvTDQr7MuhnQYP/9@kroah.com>
In-Reply-To: <YvTDQr7MuhnQYP/9@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/11/22 4:52 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Aug 11, 2022 at 04:39:51PM +0800, Linjun Bao wrote:
> > commit 7c496de538ee ("igc: Remove _I_PHY_ID checking") upstream,
> > backported to stable kernel 5.4 to support i225 Ethernet adapters.
> >
> > Signed-off-by: Linjun Bao <meljbao@gmail.com>
> 
> What happened to the original commit message and signed off by lines,
> and why not cc: everyone involved in the original commit also?
> 
I wrongly re-send this commit to mainline initially, then Tony guided me
submitting to the stable tree with Option#3 [1]. Sorry I did not involve 
everyone in the original commit which I should. I re-send this commit 
because I encounter probe failure with i225-LM Ethernet card on liuux-5.4, 
and the original commit could not be applied to 5.4 directly, and this 
duplicated patch has been tested with i225-LM. I would like this commit is
backported to linux-5.4, please correct me if I am doing the wrong thing.

Regards
Joseph

[1] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#procedure-for-submitting-patches-to-the-stable-tree

> thanks,
> 
> greg k-h
> 
