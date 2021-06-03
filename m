Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9D4399C23
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 09:54:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbhFCH4e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Jun 2021 03:56:34 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:56144 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbhFCH4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Jun 2021 03:56:33 -0400
Received: by mail-wm1-f47.google.com with SMTP id g204so2784313wmf.5;
        Thu, 03 Jun 2021 00:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=RJdmLE/yTkNDz8TCaPxLdRAfZfSVzNL4J+UU5OLCt1g=;
        b=o1IkbqQGQr7h0i/k+AVsIyb8JB2BCvbN38sh47wgpqSEEDaMjyv7wpT4oxt2SPSAeE
         liczbEXHDdG1adJg+tKaZfOHpXyV4/rzOoOM+LLpUel+GGLLEDxF98lEUFL3vdan8p/Q
         fEkGkAv1TX5axLTr40kz+IXkId5xc+waKPtlg3uxYYmSzIN/x7IbFIiRLJuCS5E+uxd8
         k+LP3a1r0v96/GlJRm+A7ettxHxMswzt3IHR5YrUMoLhelvTFgv8zFwWgSTCrzz4nM0K
         q4RqfgaJeeED2xv7Q41CLCArLN/VLwk/o0uSeTsiQxSogbFVTw7wdP2fkG8zjWBchbZq
         zzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=RJdmLE/yTkNDz8TCaPxLdRAfZfSVzNL4J+UU5OLCt1g=;
        b=tCgUMGIpVNw1ohwvvHUzxoPYiNeN9Irrp8tfT0aHPdft44AXpdlesahyMhj8v9sOwX
         v+1Xs8KL10NMSs5M+eJiV1l9a2PeJIB5hCwFPbPRkGoJZiXOx4VejXXnq3PRc3hDaiMV
         wzuPAyhEJZe78Txj2zsH1nN/UiX2ac6cgJx+2fvek5h7dQDuaDSD0a8AkfxOY13qUWX9
         l5mhBLx3tmd3A9u1/6VhFoJLMAi09FttnXI7YlQ8W+Vc3iTky98I6KbRl2W0ded+KPfj
         Jo9GPxec9WQWDjAjHCGWOtdeln4qxvZs/aac9WsgGnwp9bjJY3B2ROeUrdzMixs0X/Cq
         iB3g==
X-Gm-Message-State: AOAM531lCfFpGPlkslDgFv00XtnhAerJ2Fu/XDOysqStw7ZsGjddqYVA
        BrOoVvbWuRqe+IrPKem0gQPz65F/zADtJA==
X-Google-Smtp-Source: ABdhPJzsPjhtRZ+svmkVZt8PJrH8VRNr12TkMbyxTyDn/h281WfcT0y5hhIOm8S5q7tya3pT7myzNw==
X-Received: by 2002:a05:600c:1913:: with SMTP id j19mr8782353wmq.167.1622706828428;
        Thu, 03 Jun 2021 00:53:48 -0700 (PDT)
Received: from [192.168.178.196] ([171.33.179.232])
        by smtp.gmail.com with ESMTPSA id z188sm1941611wme.38.2021.06.03.00.53.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 00:53:48 -0700 (PDT)
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
From:   =?UTF-8?Q?Lauren=c8=9biu_P=c4=83ncescu?= <lpancescu@gmail.com>
Subject: Backporting fix for #199981 to 4.19.y?
Message-ID: <c75fcd12-e661-bc03-e077-077799ef1c44@gmail.com>
Date:   Thu, 3 Jun 2021 09:53:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi there,

I'm running Debian Buster on an old Asus EeePC and I see the battery 
always at 100% when unplugged, with an estimated battery life of 4200 
hours, no matter how long I've been using it without AC power.

I suspect this might be bug #201351, marked as duplicate of #199981 and 
fixed in 5.0-rc1. Would you please consider backporting it to the 4.19 
LTS kernel?

Salvatore Bonaccorso of the Debian Kernel Team wrote me on debian-kernel 
they follow the upstream 4.19.y, so the best chance of getting the fix 
in Debian is for you to include the patch.

Many thanks,
Laurențiu


[1] https://bugzilla.kernel.org/show_bug.cgi?id=201351
[2] https://bugzilla.kernel.org/show_bug.cgi?id=199981
[3] 
https://patchwork.kernel.org/project/linux-acpi/patch/4426745.BlFkQnxG1M@aspire.rjw.lan/
