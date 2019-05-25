Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C77152A722
	for <lists+stable@lfdr.de>; Sat, 25 May 2019 23:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfEYVqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 May 2019 17:46:12 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:35668 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726169AbfEYVqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 May 2019 17:46:12 -0400
Received: by mail-wm1-f43.google.com with SMTP id w9so6190238wmi.0
        for <stable@vger.kernel.org>; Sat, 25 May 2019 14:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tgXxgSvKOd+5V9foFjjG014cydyNAwfylD77oDfEdWk=;
        b=xwstiC9OE6tdDRFFfcRN12dpJcQVuFEsvn/knilrYiPe93uSpDEfWttXhGp3cJR7gu
         Y72SF+5NbYwvHrGwYmVYwDkcfg9ALWfSVRLZJnjqTg9YBc0hmQuUJMG+o2pR98FwFWii
         ssC8DPDkUe1vrps8qw+6La5N5Kze2UqSD024pqtiIFJnsJqMkNvPlPbgs5Iu6Xy/A58p
         zZLUviuPpaOP9SUwBRok0v9zN1t0dJibBc34bVgiuV4msHq9qgL9VD6ICSICLJpkJWu6
         GrizFJKCkws1vRXlNQ/3I+YVhCbEaXaLFHdBysgYbY7saYHADq2uw7zZzsihtHfg4yOk
         XxpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tgXxgSvKOd+5V9foFjjG014cydyNAwfylD77oDfEdWk=;
        b=Xs2LVim0oR2K6brVn8/y1ndtBEMwkDriFwJLT5+NfBsOR7SX+a+nSbaH0dePasp3eK
         uiS3aSetQjJ2IHxz4EKCQZF1NsMdZ/NY1BVfHm8GVuaodTJlAvuMt4udAJrbsCR4G8OO
         y/95XNFevKdSFM590cCS/OAs4nnbr8GR5U5yUQuaYqf5XGPIxyROql0zJBgkk+kYq/Pc
         Jogf5o0+TlHTRva/E1EobDbRF9u35e7PqWz1YT2tzgOEx7iXU+ykNmUl3rVxA3GGrUh2
         lgqeYBfZeuwuAev44gnWHoNXLfdTd/V2LgbU414PCUJ9MbMdG3nRl1f5azHAlo1E/1pp
         CstA==
X-Gm-Message-State: APjAAAXcjqxHUZ4bwa70KioA7F3LMFOerY3UXnPv0nizBaH/2zeT8ftC
        e3e65jBw7fhgv+xtBlxyykv5SK76UQY=
X-Google-Smtp-Source: APXvYqwLdT93oVOXn8qjjj7ZmwRPj6eyvZ99ogom24b9ru+vEWEMossGkabOCdFoLH6zSCNGNWgGbA==
X-Received: by 2002:a1c:f60d:: with SMTP id w13mr4440994wmc.40.1558820770591;
        Sat, 25 May 2019 14:46:10 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v184sm9358705wma.6.2019.05.25.14.46.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 14:46:10 -0700 (PDT)
Message-ID: <5ce9b7a2.1c69fb81.d9af7.52b7@mx.google.com>
Date:   Sat, 25 May 2019 14:46:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122
Subject: stable/linux-4.14.y boot: 55 boots: 0 failed, 55 passed (v4.14.122)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 55 boots: 0 failed, 55 passed (v4.14.122)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.122/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.122/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.122
Git Commit: 44a05cd896d97a3cd4f0c2ddb29a221ab2fdf43d
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 28 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
