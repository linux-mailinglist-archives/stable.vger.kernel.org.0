Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130BE2A661C
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgKDOMe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:12:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730254AbgKDOMd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:12:33 -0500
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BED19C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 06:12:33 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id j14so9182099ots.1
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 06:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=AFgsI2Fs0+bSjY9RoPYsb4awI3yXVvnSdUAL+RBrIwk=;
        b=iCbK+/04+AYQri+Nz5ehrRYEiA1vmLS+HrZNfyeXrBZuWFmeGyfCkIMNz96cDv0SY6
         buyU0kyWizfZx7/zvoOxeQBw3lKUdNS/oaUp0B6aZg3ADbYSAiW7W475i/rECEI2k4+q
         IhM/DMcTkKVoIAi3seX9Ug73qFKAgjksKhXc2TICPsQfO7k+iCWQdSyOGTnLFeW0U5cs
         wOivL28fy2erzHvd9HF6eZwP1yIhyLLoLyAGCkT89ZkJQ4Mn2pvMMLUDAUh4EzgQDWVD
         SJhEH2SABRPlzdR4mFJl5EtH9reAVxUlt3bIc98J8r0PCtz0UkHOvRf4I5vr/lBy4ae7
         JNOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:content-transfer-encoding
         :user-agent;
        bh=AFgsI2Fs0+bSjY9RoPYsb4awI3yXVvnSdUAL+RBrIwk=;
        b=IiaCziVfxw/NYZGhAq9mPy5BZfrwA7cJMg5lofAaQqlyQT06cSobNvmkA5vUq1cfCh
         uYyTUDBxjtk7CqNT2UqbATnbl0uSdek0bT8Eb1DClxWmZ1BUiILY4fkOUfkFD47atvuE
         o7xP0GW/V3Fs+a0Sg+u6V4CK90XF2S75hJVG9VY8u7B5zVb0eUCmElbNV5fkvhDlIflg
         P7sOwwxYWz+UGXF72WIvAUdsUvpZ1Wcwk8iK8n6aQpDWNLv+ja4CtmLVV9zFjK/9fTJ1
         zfVfD8N8z/q0OjhgcNNeqWGesDmBpwgZrC9oJ6lorHA1FsNuPp4/3xRgD0s4T6WI096i
         cPwA==
X-Gm-Message-State: AOAM530MKnZeOP7U3IFTrCULxtbBsUjwIUyAKF6JbTmUs4psYJDTg4Jd
        cAe63aq4Eh4hCKzP83kY6RT/qsP/aXg=
X-Google-Smtp-Source: ABdhPJy6hIFcY4cxl00UFRcbkp9UG3/Qsfd6AJhqiKlozyzieCdFWfkrZg1IJ+k+vcZgl7CvflSg/g==
X-Received: by 2002:a05:6830:160f:: with SMTP id g15mr5415472otr.22.1604499152765;
        Wed, 04 Nov 2020 06:12:32 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x190sm467925oia.35.2020.11.04.06.12.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 04 Nov 2020 06:12:31 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 4 Nov 2020 06:12:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org
Subject: build failures in v4.4.y stable queue
Message-ID: <20201104141230.GC4312@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building ia64:defconfig ... failed
--------------
Error log:
drivers/acpi/numa.c: In function 'pxm_to_node':
drivers/acpi/numa.c:49:43: error: 'numa_off' undeclared

Building powerpc:defconfig ... failed
--------------
Error log:
arch/powerpc/kvm/book3s_hv.c: In function ‘kvm_arch_vm_ioctl_hv’:
arch/powerpc/kvm/book3s_hv.c:3161:7: error: implicit declaration of function ‘kvmhv_on_pseries’

Guenter
