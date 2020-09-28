Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F35A27B07F
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbgI1PER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgI1PER (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 11:04:17 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A75C061755
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 08:04:16 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e5so1554297ilr.8
        for <stable@vger.kernel.org>; Mon, 28 Sep 2020 08:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g2jiIIFwMI6+BnC07dULlYuTPLw/sIvuQnNCrgpYl04=;
        b=sm0kx4ik96+/iCAjWvOw/pUfssZrNdhS3Xan3gWxn99MLKouHQq8Q89yDXsGmLINm8
         tPfcZxvao6ogbTdtZX59JYCfa1ZRH+r6DG55hgJcbcDrajRNCmJ4BYvyFEXcar89PeSQ
         rMQkispKA7DazbcxAS5kir3ZiA3VJJAjWV8espKQuspPTlhuu7BAA7msmjwSQKcPQaxG
         aLIxFwTSUupqEtYp/EGkf8njKvIJtGwodq6tRNpIRQTLGxLQFPyryY7nUQmgpozuBorP
         56Hu0tHlRNbntaEHXmevTIKuyjeGmbyIk06ZzuQirVuXFotWMGrgmxtcqxQuKdfbpwMM
         Bx9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g2jiIIFwMI6+BnC07dULlYuTPLw/sIvuQnNCrgpYl04=;
        b=jmPnX5yTV+d8H1XnMj9AcfvC29u51NE3xijHTeCLmfpcxy3/bCsOcbLEThLIH43z4h
         +SFQQWJMDBQ1luNvveYTpiPae7kY7AMTC2MJSZCvTx0wMiH9/CRuRH3zeMlYu0ArTZOq
         fALrS7IdMjH6F5gDqQV0XQuK0cNi8zSUrriyaqorYv+0EFsoIFl/yYg4C6GntI6jE2AO
         3kFcgE8PDwF5lyPBeqHpoNdWOLW8/ZWCGD+8pnXHoGN76DZjDU12f1ZOhIOTn4NrzIU/
         qshAm6xCXYtUdD9rI+r94Gp/6Zv8DUG+GgLlKRlUkTJGfFMAJ9QT1VB0r87iTtPTcbgp
         JeEQ==
X-Gm-Message-State: AOAM530wgQuNkNQCDL3dcKtT0kGg6qC7Oc2r5VqDN38SDNt77MIySw32
        JuZzI9NkWc2o3LNEVqGPtlqSonkThHoj7A==
X-Google-Smtp-Source: ABdhPJzp5YHGWUECQQL88H3zkDaLmdXwgJD1u5C1MTn4Bd/cboJPn4O+2pnOJEQv+IIkBDBrjlCXig==
X-Received: by 2002:a05:6e02:925:: with SMTP id o5mr1587326ilt.20.1601305455238;
        Mon, 28 Sep 2020 08:04:15 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w13sm690531ilh.78.2020.09.28.08.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 08:04:14 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: ensure open/openat2 name is
 cleaned on cancelation" failed to apply to 5.8-stable tree
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
References: <1601301865177128@kroah.com>
 <20200928145204.2kgheql4qfffz5s3@steredhat>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <86e4cf92-2871-539e-8eb1-4bb8f8fdfcc0@kernel.dk>
Date:   Mon, 28 Sep 2020 09:04:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200928145204.2kgheql4qfffz5s3@steredhat>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/28/20 8:52 AM, Stefano Garzarella wrote:
> Jens, if you want I can do the backport for 5.8.

That'd be great, thanks!

-- 
Jens Axboe

