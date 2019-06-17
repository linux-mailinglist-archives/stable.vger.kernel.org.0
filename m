Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61D1549557
	for <lists+stable@lfdr.de>; Tue, 18 Jun 2019 00:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfFQWnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 18:43:00 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:51563 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbfFQWm7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jun 2019 18:42:59 -0400
Received: by mail-wm1-f47.google.com with SMTP id 207so1098926wma.1
        for <stable@vger.kernel.org>; Mon, 17 Jun 2019 15:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8NxhGwDxw9NuiwlA6yejHOhEVNURBx0cZN+egnqlbHQ=;
        b=p5bA0zHRcRNFXW5yFQ2iwIlXSVKLIhZXHm+S4SJSBPOop1vmRGvJ0Mh3Ut+JpK0bCo
         BSMHM3OliEtzo/71a+h+GtwEMui9pF9saE384zO7O3fOzZF7ActxZWaJKbGpH8xVXCN3
         w1bHAu22ZAn5SzP5xAbH7o4hWPGC26zbRKOhP1iVnhB3DbZ5But+oLnjqFpdn48RuriI
         jth5+dkeM7c7sBTlkch7rKiYVm21t93cB3FFVp5ollLXYIxtR7jEN6lT0rAMAGV6PxbS
         eT40J5JOPq8URwIAKY0xeERtag/GISsz0spa87BdsZvI+E9IDe2gDZf1P8885ImtfKMk
         ROiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8NxhGwDxw9NuiwlA6yejHOhEVNURBx0cZN+egnqlbHQ=;
        b=M5Eb+v1o9x0vfkf/ybGtGPIk0id6J8LLaGUAInmgKg6v4wdvd7gTyFXaaD+ZaXophM
         SM3tAVtn2TIRtkTkvjjcttXVjNa2BK9sq1XqaODQEd4qCNs8sZnJUGvuQNKN9BMBDVL7
         b0AgUjdxFJm5r0Qq38L3FOn3/3qUUocdrBv88jprG9jRwmmEOw3B3Fb/OFG6QNV5a5iz
         z6sJ9XXENAVTv5oji28997B6S09+QVbQyfGx5LTXafdcql43+ZUKl4k56rg66eIAjGwT
         AscGYHN6NertKTYUPk7RaSOqosY8O3PoJ8Iyg3y4Mncn8qPkwVKeJYsGCOzYV5qLlXWj
         SsKA==
X-Gm-Message-State: APjAAAVdF3BANWFveVRxM/MtaEigxh+0uetMuRLCF2+5t6Ou+VqNzdab
        ERodCNM1CN6fS/nRqe/SoswAwBXn1O3U7A==
X-Google-Smtp-Source: APXvYqzTL6uPyWqf+kRDNvD4ZxgXgvu5i64ixLTeRcDvWailIYTB4fYvaZOqZ1PjcTeO/3NDAsjf0A==
X-Received: by 2002:a1c:7008:: with SMTP id l8mr552606wmc.64.1560811377443;
        Mon, 17 Jun 2019 15:42:57 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id r2sm438289wme.30.2019.06.17.15.42.56
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 15:42:56 -0700 (PDT)
Message-ID: <5d081770.1c69fb81.d465d.29dc@mx.google.com>
Date:   Mon, 17 Jun 2019 15:42:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.52
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 53 boots: 0 failed,
 52 passed with 1 untried/unknown (v4.19.52)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 53 boots: 0 failed, 52 passed with 1 untried/unkn=
own (v4.19.52)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.52/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.52/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.52
Git Commit: 6500aa436df40a46998f7a56a32e8199a3513e6d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 30 unique boards, 15 SoC families, 9 builds out of 206

---
For more info write to <info@kernelci.org>
