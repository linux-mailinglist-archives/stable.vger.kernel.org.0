Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B801124675C
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 15:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728585AbgHQN2H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 09:28:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbgHQN2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 09:28:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B008C061389
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:28:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id f193so8232386pfa.12
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 06:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qGSlfV6VrLNSAo/QIL8eQRhaA0Cl1ZGPR2nyVerKyZY=;
        b=Hu53zMxxc3+GC70lZUs7vMkLbGr+AsUtFHexlqFxgpKFTvNdHc6idxeXGTk+3vW4WG
         6pcu2lpc514u+B6zBB+7IMsFEu8PI6N7TD7e3r4GWq6pZzOreYDPfVeumIT4uOAfJEpP
         BMYQW9EDbrZNKguIygY7fa79RyhCSQWxPdvfOx/e8F3mGOlXlRpVZFgEST8R7zXvZ4ns
         pZuGx8e+sSXrOW2td48zGQ6RbTsOHuJcLO2B33q1+cagyVnA+AZmgNMfww9VzLe6QCHT
         rZztizp6+TfYuxHu3uglM7wuQtcUimuvYEyx75nqul0TupDQlWwr9fIF435iLxMQhB9x
         VKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qGSlfV6VrLNSAo/QIL8eQRhaA0Cl1ZGPR2nyVerKyZY=;
        b=YBmAjKSdoMwrVwZmOfq00gaP9iKGDTKxPPd5stJd6j9TfTd8aUSMKMxuyOgvQrfLgz
         F2wbcVgxIGJ2TizeIAjookvG5TCFZmLfGMaDZQ7KCGPZhDJWEtZ4U8B58M+nAPdmqoYA
         nhiDxYZwaRaT3NEJKiuwC9ZdF7jqWi4PBp44Vv4hQ4JwoAzq61XAEymH0WoVTlbMCdms
         lTLlhbrYQdo8pXLfRDzWTQYnE7lRCKxbOjz32G4MA+NKj+YH6gqEouG/PylqQnVeP7h5
         66/qP4iQgDLlpsEdGaRBegIZ+v21R3t8949NgMbYBOrWof7kT9vR67Au+EAfhGj2Npxf
         KqyQ==
X-Gm-Message-State: AOAM531cvpYb1yCAMtL685n8QoPU/rDtm0FzI/vfWwkT6bNUzxIiK7GI
        1pUOP7vggqFCwYj/vuDmYFiQexIfkHm79A==
X-Google-Smtp-Source: ABdhPJwRIUIeeFnMaf9VS9JFl5dh+5rRqgY407D4v99b+kuZxU81VJ/8/ZADfdGm33fOco+CnXZGnw==
X-Received: by 2002:a65:48c3:: with SMTP id o3mr855762pgs.224.1597670880820;
        Mon, 17 Aug 2020 06:28:00 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:ff2c:a74f:a461:daa2? ([2605:e000:100e:8c61:ff2c:a74f:a461:daa2])
        by smtp.gmail.com with ESMTPSA id t25sm1715627pgl.60.2020.08.17.06.27.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 06:28:00 -0700 (PDT)
Subject: Re: FAILED: patch "[PATCH] io_uring: hold 'ctx' reference around
 task_work queue +" failed to apply to 5.7-stable tree
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org
References: <159766104348155@kroah.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <5e62e5ea-6bd4-5d43-b836-a4f012bafc7c@kernel.dk>
Date:   Mon, 17 Aug 2020 06:27:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <159766104348155@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/17/20 3:44 AM, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.7-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

5.4 doesn't need this patch, only 5.7+ as per the Cc stable instruction.
Did I type it wrong?

> Cc: stable@vger.kernel.org # v5.7+
> Reported-by: syzbot+9b260fc33297966f5a8e@syzkaller.appspotmail.com
> Signed-off-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

