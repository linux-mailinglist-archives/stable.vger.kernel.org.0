Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E85EE943
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 21:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfKDUMr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 15:12:47 -0500
Received: from mail-wr1-f54.google.com ([209.85.221.54]:38537 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDUMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Nov 2019 15:12:47 -0500
Received: by mail-wr1-f54.google.com with SMTP id v9so18626482wrq.5
        for <stable@vger.kernel.org>; Mon, 04 Nov 2019 12:12:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9krvnIu9OS7GUpa1I8nAf6Vf9a5Plk6qMhFwuJDchko=;
        b=rIrhsHi2mTgkzKWQTiS/dXvMohL+e9tT+sCjQ8x6LJ4QahTw/JJ3A4OiaAJA2/cpqw
         cKw+7SZcFO2XOPymgqA95CGEcxtE89Ce5h1owSLvMGKVK8nv7WZvh9BiyBay4ipEDOeD
         LwEkZtxFxKmYvCbLnrnCRYYWcLlsnhQvwSQTjfzUX/KwN99AvdXfEiw9hbhmSnhoRrcZ
         8Mgr2sl5JRLh8QqFHaWR0BabV/t1qWlonclnibI4yN37EoJNuXJCOrVb3R8b8rsuAgc4
         rTkzVzf803mekTFkoINZrii9t82cfhbba0Uqk+3A+7E6glb15UOW4it+gLNFjmG9t67o
         qcbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9krvnIu9OS7GUpa1I8nAf6Vf9a5Plk6qMhFwuJDchko=;
        b=qPdHkMfZAs8xYJ0FGeRwYmwp6/I1XTjevEHIfwSFEAuR3PGJB41tf7GsX5iCuqMe6/
         BL1hRSz3Y+aRM+mnRkfDcGBgX0TLrTt595RIW4MW8x+wTDY6g9oAUG0SgF4EaPEYZI9U
         O7xSi7kVgZyKh8P1j6VlzdH2MvuoyNqy4PvfHqcjo+GcynSO9kD5GtdRLBcu1e5FOi2v
         qoVqHt6ImWymRY+e4em0BCmGbtyOuhBG46rIkYZhaH4pbu6RXtKisn2Ti0G80d+UsJWy
         Z1b2nLpp9O3kZh8jeiKHs3EPEWi6gqWgiT9Uz945/F0E6ScFyV6DRzqJGq0GCOWTjHdS
         eKEA==
X-Gm-Message-State: APjAAAUJf8g5e5mjzT6bLiohRWhukMb3hI8gzZyo76XJ54lFFbYX0USi
        oHzKQGd4Rimf4rtM8BRGBt2J25E/800hIw==
X-Google-Smtp-Source: APXvYqyg44+cJ9bQUw+QhLWR/iL7hbn3uE47eQuujCWFWkg4wDU2o4tnLSRDtFqozYncfyOblpO8pw==
X-Received: by 2002:a5d:4684:: with SMTP id u4mr20775015wrq.352.1572898364968;
        Mon, 04 Nov 2019 12:12:44 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v16sm19327018wrc.84.2019.11.04.12.12.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Nov 2019 12:12:44 -0800 (PST)
Message-ID: <5dc0863c.1c69fb81.9b244.e9a5@mx.google.com>
Date:   Mon, 04 Nov 2019 12:12:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.151-94-g14ec99d62d85
Subject: stable-rc/linux-4.14.y boot: 60 boots: 0 failed,
 60 passed (v4.14.151-94-g14ec99d62d85)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 60 boots: 0 failed, 60 passed (v4.14.151-94-g1=
4ec99d62d85)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.151-94-g14ec99d62d85/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.151-94-g14ec99d62d85/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.151-94-g14ec99d62d85
Git Commit: 14ec99d62d85e6c04324d05f099d70fbb9995b52
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 13 SoC families, 9 builds out of 201

---
For more info write to <info@kernelci.org>
