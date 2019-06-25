Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF1D527A8
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 11:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731409AbfFYJKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 05:10:45 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:36721 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728823AbfFYJKo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 05:10:44 -0400
Received: by mail-wr1-f45.google.com with SMTP id n4so15742558wrs.3
        for <stable@vger.kernel.org>; Tue, 25 Jun 2019 02:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Oq5zCAQIz1HS39aOg7TtOT+Sd0ksbD7w7UIyVCMfUY=;
        b=v/Xa6VGv069PSoMOBaOazQLDBBiKTOdFgVbv4Ik0TTRS9RXjr9hweIIeGp9RV8VSpA
         n78unaMIbZLGusPwbPgoBpreejic8TCYsZGMSizssxhjqpfsn552PKRCeLpex0BTiP0D
         feI0Q04xdGw7Rh6XQZLO7JipIxl0SyHvNuYk373j1GbwJ++z7Cu+/A8qgPpm35OdzBYI
         Aor+HAS2NhHWNOC7kDRy0nl7lYTcyk2ocCKhJscgAIiJyywWnox1uhfPpcyQjiR/RJCj
         IMgY94rb++AJWBg/f5f5OvtRDd0hc/CfVRwxyumA3gydIhtjJxCeIhTkgZvUyFda3wZ3
         b/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Oq5zCAQIz1HS39aOg7TtOT+Sd0ksbD7w7UIyVCMfUY=;
        b=UEWk02yksq9U/k4vlFsL+WAK0+8PucZkOz6x8rceq9GHn/fOHMfS4b1Pq/EUu6KDh6
         cGGz4CEk638wzkb/OL/ddJHU6AxtNwIDrotfJZmifAOKXa9iJl0A3xWgnAgTfo7pLa/g
         GEaUnd0meYEkrJaYBft4VmDGlDoUfnSWQ/ZmAMI8c/Bxjp+56HtuWKauBna4qU11E53j
         Iax/ePk0n6yALkkbaw410WJrdG2PesqiUHZQV3006U231yI0pQlvp0De8xB4GcDiV8Bz
         b34ATR0oIgaCU+WudklJVtL45upZLquNrX8XcoXI/RacGhrgwv1QpRyot4zKdYF9bo+S
         Vx3w==
X-Gm-Message-State: APjAAAWe1+x6HJKpNhozj8VhWTfSjv27ZADxYMrEtSSgNi6sJ48WrwAj
        A90+ndTzijQCxrW3MsNHXFmP6aQv8J/weQ==
X-Google-Smtp-Source: APXvYqxtE00TlQrQ6TQAq1r7MsZqqNnyl49SQ95qMhObHxrMgaCyL6LiEHM0LlEYpDtgRGOHsajuPg==
X-Received: by 2002:adf:ef8d:: with SMTP id d13mr96158000wro.60.1561453843065;
        Tue, 25 Jun 2019 02:10:43 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id b9sm10611832wrm.11.2019.06.25.02.10.42
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 02:10:42 -0700 (PDT)
Message-ID: <5d11e512.1c69fb81.38337.9035@mx.google.com>
Date:   Tue, 25 Jun 2019 02:10:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.56
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.19.y boot: 79 boots: 0 failed, 79 passed (v4.19.56)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y boot: 79 boots: 0 failed, 79 passed (v4.19.56)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
19.y/kernel/v4.19.56/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.56/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.56
Git Commit: aec3002d07fd2564cd32e56f126fa6db14a168bb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 41 unique boards, 17 SoC families, 12 builds out of 206

---
For more info write to <info@kernelci.org>
