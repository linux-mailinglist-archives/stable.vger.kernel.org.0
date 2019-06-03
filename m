Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEC5332CB
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 16:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbfFCOzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 10:55:53 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:43120 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729048AbfFCOzx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 10:55:53 -0400
Received: by mail-wr1-f49.google.com with SMTP id r18so3410508wrm.10
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 07:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+v0ksz+v1QeBz3AO0+lw6RHxL2RhfcevttjzMHAowN0=;
        b=OwWbdtzIdzt4gfYvD/g1v0wTstR9hz3EdCTb25Msy7IoRzLBkeJNrftpVYbRl5Zrdz
         2K/Ub7m9qfVmG4Cassk++CE8GuhCyL5Bf1DgYwmGQPtdVj8FZa6oEDcpuh1M99wayP5d
         WiN0OTQZRI0VAmOwsEu0/b+wExLPwIW1tnZzPokBEgQaJ61mpQeBWaYEktRn8aMkfSU1
         PjvL9CYZyqbG+myWBWCUt9icNw0R2SB6N5Yi72V0z9wT+lhTkoKWhP6ly4yD0YCrlExg
         HewRHb+E3dvkwjIk6Le7dCm7+mjMALwyD9AImmGusXIdtRKc3YI17tuZWjR20CgCeYme
         YTXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+v0ksz+v1QeBz3AO0+lw6RHxL2RhfcevttjzMHAowN0=;
        b=lW2yZWItvm0rPNvWDcSmHQXoeik6Z+HUb/oQ2xqfk/ZuXFgu5bNrxbLFoHFHH1sIZo
         kz+OS/0JB2+7VuHIQvJTX3r3tab2TL2KlHantN57+HK/RJwiZ5MxsXfGZLnrJ4fpqA/Q
         vV6NhrEZxjKUgv3aKRxcYytLb7DzjXct4e9i70Aq/9KDJH9GOlybydPreqSbx5N3ahr3
         8omDD0/73ZT4AMa2+YgK9kXj3RepcSI8es6hWz0iuBVhpXEyiytELbXvth5PZvBBW0wh
         3HVUrsIiUwmLxsgUg7NcSt5GyOyED4dEkDp+yQcT/urQLaeuF8f9mi985iwM70ujKOeE
         e5tg==
X-Gm-Message-State: APjAAAXHapdoynsJSjmSMqkYvnPZuFGCAcsHoDZ/bDJKahPTWe92sO2w
        bNgmwnIXEM056uVz0ySlASVWZzaUau9Vag==
X-Google-Smtp-Source: APXvYqz0dloyVO4uIV7xP083+Qrl1eUZUFNvPyoa0+ojYcpeDf0MwoB3uGwaxTzThddOqo2+KN1MeA==
X-Received: by 2002:adf:f8cf:: with SMTP id f15mr2835084wrq.333.1559573751295;
        Mon, 03 Jun 2019 07:55:51 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id l15sm9880362wrb.42.2019.06.03.07.55.50
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 07:55:50 -0700 (PDT)
Message-ID: <5cf534f6.1c69fb81.f093f.8dd1@mx.google.com>
Date:   Mon, 03 Jun 2019 07:55:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.0.20-37-g9866761971ed
X-Kernelci-Branch: linux-5.0.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.0.y boot: 132 boots: 0 failed,
 129 passed with 3 untried/unknown (v5.0.20-37-g9866761971ed)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.0.y boot: 132 boots: 0 failed, 129 passed with 3 untried/=
unknown (v5.0.20-37-g9866761971ed)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.0.y/kernel/v5.0.20-37-g9866761971ed/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.0.y=
/kernel/v5.0.20-37-g9866761971ed/

Tree: stable-rc
Branch: linux-5.0.y
Git Describe: v5.0.20-37-g9866761971ed
Git Commit: 9866761971edf6312f8144e0b73e8e831883a461
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 23 SoC families, 14 builds out of 208

---
For more info write to <info@kernelci.org>
