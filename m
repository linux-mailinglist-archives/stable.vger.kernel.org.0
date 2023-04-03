Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28E7F6D459C
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbjDCNYQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbjDCNYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:24:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B3623686
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:23:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BCC33CE107E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 13:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F790C433D2;
        Mon,  3 Apr 2023 13:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680528210;
        bh=nNykaOg633fVwK8v6tm6oav6eCoBmYmEEkJKgBWfBvU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EY/ccu1IByfSpPYkd4YX/WldmHdB0Zd7M4m4hKY6p05xDo2EeDm57eo/F9btqofvZ
         7KWh/mD9ziqoKioMktKrKMFbgpwTGG/27nziUuVPRaeT1O1u+zwbiGPdQ//Ei0J9gT
         N4Sd8wqlTCKmCv/b073JOcE9c/QxPUNwdzuB2nXs=
Date:   Mon, 3 Apr 2023 15:23:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org, edumazet@google.com,
        vladbu@mellanox.com, davem@davemloft.net, xiyou.wangcong@gmail.com,
        kuba@kernel.org, dvyukov@google.com
Subject: Re: [PATCH v5.4.y 1/2] net_sched: add __rcu annotation to
 netdev->qdisc
Message-ID: <2023040320-pulmonary-washday-e275@gregkh>
References: <20230403033140.3229863-1-zsm@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403033140.3229863-1-zsm@google.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Apr 02, 2023 at 08:31:39PM -0700, Zubin Mithra wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> commit 5891cd5ec46c2c2eb6427cb54d214b149635dd0e upstream.
> 
> syzbot found a data-race [1] which lead me to add __rcu
> annotations to netdev->qdisc, and proper accessors

Both now queued up, thanks!

greg k-h
