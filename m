Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACD403940CD
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236395AbhE1KUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 06:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235361AbhE1KUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 06:20:36 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFAFC061574
        for <stable@vger.kernel.org>; Fri, 28 May 2021 03:19:01 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id n5-20020a1c72050000b0290192e1f9a7e1so2095514wmc.2
        for <stable@vger.kernel.org>; Fri, 28 May 2021 03:19:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raspberrypi.com; s=google;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=6qVNsNOHOXttvNFzvOcpkOuxMebFYKWVIPtq4G6P/0k=;
        b=d2NnsgRmQA+n+ij2WRWpREE1vn4RDF40OVlcoYVQ0qfOgCBlco8eU25ac1CAtyXhbN
         NHgGUVzAmMQ34P9fG5vGsYpKyQA+Ibyuo04OgviwSuLciYPslmzwU7Bcw5HWRUZW3RvM
         Iz29zN4FuGLnI8L1T5dmFhVugRw905hyKSFyfrhRxy8g9hdu5MfF0efjjmFjYtQUhl1T
         Ntiz4wbB35wnRIaOnbRZH4sB5Rx4S9AC8OTsVcRnhBhOqlrSIOpHnmd2CTiUsVuO1kBP
         41qjTDLhVlez45bkziIOLP4GvJEJsRwwo1X0D7ApzQJYVRiE9pHuci9TeMNrxBukIx5q
         4+Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=6qVNsNOHOXttvNFzvOcpkOuxMebFYKWVIPtq4G6P/0k=;
        b=XF2ywjWnQ/4VyZLZAKoazE8aeqtHW6vtWJnMTy+cf5C5+XkzCr7gKf8UYuIiYQM5RI
         loAO30htcvVoxUmAaooOr0SI+PVxxYD6gZrXnVTKrzXEz4uAXur/Bde+9omJ3eMjtniT
         jlHkSUrvOjcAQwcu0apMw6j99rClss9632/qL/SCdjNvGiZVOi2CAbY0Im0DJoQy+2QU
         vIb1mjPOwQ9Rhq/QwNG+7G/r1+j83/SJgYic04k1FUJzGuErL9eYqMvWEAcxkYSNe34n
         Jn1Ml0bC8aTTuPm5i7eVmbMw+ACZv8Hx9LjfS3EOuHQH820+e9enrqolk4F9aj83Sv08
         vbzg==
X-Gm-Message-State: AOAM531iB+91q2irZ5f9WaSe9BGHPDtxQjkojoeZwDTqfZ5lS5H0XtwQ
        LGgbNPiakFW0fxKGmPFOD00B56VKcuUerac2
X-Google-Smtp-Source: ABdhPJxNFAQU0LHlsE81TQrf3gaS6e8QSGUmpGSidwU13zamNlHvWECq1YYSgA3v3GrmPBXAXs+CpA==
X-Received: by 2002:a1c:f303:: with SMTP id q3mr12854844wmq.9.1622197140187;
        Fri, 28 May 2021 03:19:00 -0700 (PDT)
Received: from ?IPv6:2a00:1098:3142:14:8130:4d4f:4238:e763? ([2a00:1098:3142:14:8130:4d4f:4238:e763])
        by smtp.gmail.com with ESMTPSA id b10sm7784114wrr.27.2021.05.28.03.18.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 May 2021 03:18:59 -0700 (PDT)
To:     stable@vger.kernel.org
From:   Phil Elwell <phil@raspberrypi.com>
Subject: Back-ports of dwc2 commit break peripheral-only builds
Message-ID: <558ce64c-666a-5b68-ee48-74293b08cbbc@raspberrypi.com>
Date:   Fri, 28 May 2021 11:19:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Back-ports of [1] - a Fix to the dwc2 driver - cause build errors for 
configurations including CONFIG_USB_DWC2_PERIPHERAL=y because in the stable 
branches the bus_suspended member of struct dwc2_hsotg is not present with that 
setting. [1] depends on [2] to move bus_suspended into a common part of 
dwc2_hsotg, but because [2] is not a fix it hasn't been back-ported to stable 
branches. [2] does not apply cleanly on its own (e.g. to linux-5.10.y) , so 
either more commits must be back-ported, [1] must be reverted, or a subset of 
[2] could be used for the back-ports.

Phil

[1] 24d209dba5a3 ("usb: dwc2: Fix hibernation between host and device modes")

[2] 012466fc8ccc0 ("usb: dwc2: Add device clock gating support functions")



