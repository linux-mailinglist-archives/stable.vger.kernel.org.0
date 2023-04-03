Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791D66D4582
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 15:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbjDCNV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 09:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbjDCNV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 09:21:58 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12CB2A275
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 06:21:57 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id q5so9928633ilg.12
        for <stable@vger.kernel.org>; Mon, 03 Apr 2023 06:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680528116; x=1683120116;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rj+XBi66tsf52ohT3CTSbvXzVqK42x/ATg+RJOJGG/4=;
        b=c33iwN4ZdIAbU1VQzZewRLnKQ5KGTPTBge7TCurvoQVDosqaNrzooubZGrgKSdDjjA
         lJcoXQZJxux8FPstO7t6tuFDvPc7BzVkB1NsSZ2IsAOEjm1ne5FctF4wozGwbQpK3ioj
         x+aLoRnkqGuuJCrlAOzR7Kp/epGIn70/fBuYzbUydUWaFgOqMi7wlft1hBn2zXxPKnO8
         bKs84JmdCzbKLzKzrzBY7Iu43Piwxbw1fAto17h/uvKFcgwCI879Kse/RmC+zxLdacp3
         G3kxYD3fz1DN0ycEMkDMMskGukWp2XD5RGMMzJ7Dw4atFIzOETIq9rAfF40cz9Df/XIs
         8ebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680528116; x=1683120116;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rj+XBi66tsf52ohT3CTSbvXzVqK42x/ATg+RJOJGG/4=;
        b=e6FTGSdpUd+5QQKiJzHAbKmtfBbHiRSM4ZproHfqiJfnBlpFit7F0ag0a42kc3ylrh
         Sm6y8h/AISmhFEKsedKGsEBndUXSdsiwsult1bwQCbsAgKEjzxllzA2RBTNaFKj85bzn
         nj7NO0wshp9dSzoDte7fzZgtfVt4fZzAZoz7ELZu3/Jufatf+9K9X1JY2lldyXHdSC9Q
         JIyMQK0hzHv0YIdqOx2hRsitEkV7Xs/+dMO0h4J1dfN4PtjwNtaGK86FdY2efMiM4Brs
         b9KLFV+zx4/2ipTGWS/q/P43Rfj5+WEpn1a0elbbhL3H4LJBTRI6FCBl+HHGNMIaHS+K
         cOPA==
X-Gm-Message-State: AAQBX9cXDO0RctJi7bCxYYp32fr/EVHQqnjYWo3wcd03UMqYLs79FcpS
        xycFfJb1ZgmjRu65+mcRMsi6qYbUga/l96CedmE+rA==
X-Google-Smtp-Source: AKy350YJIVO98Qqgt9yJnOVxoApV+Qw6PRkPinjm8NlP3fqrYilJV7+kfdHcLCtmqZY6loJ0ZVgEVQ==
X-Received: by 2002:a05:6e02:b43:b0:317:94ad:a724 with SMTP id f3-20020a056e020b4300b0031794ada724mr20004376ilu.2.1680528116277;
        Mon, 03 Apr 2023 06:21:56 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a056e020f8600b00316e54a8287sm2649438ilo.14.2023.04.03.06.21.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 06:21:55 -0700 (PDT)
Message-ID: <c6134352-74a1-d3c9-5a21-e0e6822ed0f2@kernel.dk>
Date:   Mon, 3 Apr 2023 07:21:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: FAILED: patch "[PATCH] powerpc: Don't try to copy PPR for task
 with NULL pt_regs" failed to apply to 5.4-stable tree
Content-Language: en-US
To:     gregkh@linuxfoundation.org, mpe@ellerman.id.au
Cc:     stable@vger.kernel.org
References: <2023040302-flakily-define-371e@gregkh>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2023040302-flakily-define-371e@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/3/23 2:40?AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

PF_IO_WORKER doesn't exist before 5.10-stable, so we don't need to
backport this patch to older version. You can drop this one, and the
ones for 4.x.

-- 
Jens Axboe

