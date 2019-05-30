Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18DAB2ED65
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727409AbfE3DgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:36:05 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:40591 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387568AbfE3DZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 23:25:33 -0400
Received: by mail-wr1-f43.google.com with SMTP id t4so3113198wrx.7
        for <stable@vger.kernel.org>; Wed, 29 May 2019 20:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mCXNS4fvbwaDUScUh17n37R76DJBI88Q0jDpj60X6yk=;
        b=kCApxhi5Wp3E1VDt6T983G4dAzTzjE3N3VX2vlTHMLXoaHVFUuZS7yzx1RYiSiLwm0
         8ucKzvbhwg7DymQVJK64CHtDCYzZu0moW+hpe87StLmipqUxWAaJkkQOo6lkatPsNkT7
         bKBOp04mrQfhE15Dv6t9RN7ruCcnsndxfKm8Wodm9G/3xjHwsp98Dp4wGvKdO4dpYycJ
         B7wL9XLAIKu/t6PupzE5i62JtlgXxrQurJ5IAAUfYxYdCKw0Qq3/JKxiDe9kuOWPlsis
         TUVUgu8yYegMQxPaTWEermvR+ScgR3wtDFsmAEY0wZ00yBh1JwiefESmKT4RH+9ZTfA3
         4j8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mCXNS4fvbwaDUScUh17n37R76DJBI88Q0jDpj60X6yk=;
        b=oP56wVC6TT/pkbAf4/nrqN3UDu5tuBm43b20ezaEWai1btATSHSxigiUSms1RwnqZa
         OR3vQ4KKO9KeqsNWyj2y5qE+fjwv2VDZbR2lvDXL+28yRSuNZaJpznmJ6s7sZaOh4X6w
         CDrWnF5Is+1qeYVz/n219+WvofWLRtfepGNqkCy2oi8w/yrc6UPAgXLoNtdir7vDzwjQ
         6lLlFbidKDKtIFufpRjsP1nsgv2Wn5W+Uv3r8KYBsQ52LPqU6h3z2Jkei9f4y5cN1E5K
         VpibKLkFpbopUhdNna1ThSIQYWSTAkinag6upWzjcKizccC9T6mIMqYQilj0BDDD8CmI
         sWiw==
X-Gm-Message-State: APjAAAV5w8HtOraK5kl9QQ1HJX4Dk1ne8zoXEuuIcGvKwkxeUk0je7Fm
        4lmRD0P4NcA78Zp3W5UBrN2SFM7vMUqdtA==
X-Google-Smtp-Source: APXvYqwvxXRU/VaZWCeFPKMc9apVThbdLdLmMPaBEAlzmsb82h85C9GcdQsSFjTE9poobHg3422PKA==
X-Received: by 2002:adf:fd0c:: with SMTP id e12mr775451wrr.262.1559186731904;
        Wed, 29 May 2019 20:25:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h90sm4267005wrh.15.2019.05.29.20.25.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 20:25:30 -0700 (PDT)
Message-ID: <5cef4d2a.1c69fb81.12cc6.5e5b@mx.google.com>
Date:   Wed, 29 May 2019 20:25:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.122-36-gdb017ab939c1
Subject: stable-rc/linux-4.14.y boot: 115 boots: 0 failed,
 113 passed with 2 untried/unknown (v4.14.122-36-gdb017ab939c1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 115 boots: 0 failed, 113 passed with 2 untried=
/unknown (v4.14.122-36-gdb017ab939c1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.122-36-gdb017ab939c1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.122-36-gdb017ab939c1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.122-36-gdb017ab939c1
Git Commit: db017ab939c18cab5b4b34ce1c92fc38f3ccc292
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 22 SoC families, 14 builds out of 201

---
For more info write to <info@kernelci.org>
