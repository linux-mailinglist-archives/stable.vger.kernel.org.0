Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5389EAECA8
	for <lists+stable@lfdr.de>; Tue, 10 Sep 2019 16:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728759AbfIJOKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Sep 2019 10:10:38 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39206 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfIJOKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Sep 2019 10:10:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id t16so20578513wra.6
        for <stable@vger.kernel.org>; Tue, 10 Sep 2019 07:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rb8uUz704Rfws4E0jGykgu75QUTDXPM3ODMS8RY3ISM=;
        b=kQ38FUCLN95k36Dlo2CZ1uWgZgq0YeDzUpcvKjL/gYuWK79Ixp2Ww45ig3Yp1VzsTr
         tsqQFPkYz4L9O2pAs92k9j8rFz1z04+oG0MJz/A/aFIOCdXtEG1el50SRjplhLo/oEr9
         KWEPo7acjmxvO4rjVuKlLe+d6XwBZH9Eiw6mlwrAxhnay9deifDLmboSh9+O97LZ/f8z
         is3plek6Jq+bvHuVKAmB6d1ha7KW1JhnYIIl6Y28TD+p+R5wFNKqKujnLzzmlMJHAX2G
         l/vksWXA5WmOrYFmyCyaGDotZDTdrPLrcFmtonl3k4F33KlB47PFiQvbzP/5esDGF7SV
         j0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rb8uUz704Rfws4E0jGykgu75QUTDXPM3ODMS8RY3ISM=;
        b=i/HXBRWs+nlbPzRwP5qXhp2k6CeC+DwyiCrZdyz0BFJWgOkGqJPZyhalLIELQdCoXo
         sFtvMnjaehRoAuAfXvt4VkvU+Pt7ETMBjt3BCJQB5+7oDDhte5TyG+k/XLI4OgXRALJP
         D+960F9gB/IKqq9gJGXnntnQr+zhM+6U9EL9I4YguyBVzV3tYqcMS3+FAjtSUQkxAeOm
         zKzpZzYnCYgo4Uk9WIWk4E8ZY5h2jKop5Wd1WrtO00vVERf0kQnjR5VyCmGBL764E1kl
         skk2Bcd2w492wOKXtUv+6ukmZDcMVOxX7LtnsIil2Do3WYofsaqlR6dZdIZbNM8YJXTu
         PIMQ==
X-Gm-Message-State: APjAAAX/3ArfdofpnsZCskNirj8OX/wg/hy2WEpS6wZzoCFTOXHhj9dq
        nSyMOLgw+BK2Mo9rcS7DRK9lJP7lBb2Q2w==
X-Google-Smtp-Source: APXvYqzGLYXAOgjydx1lJqtWIWNxVdNKDU8v3BKlSOvOEOX5rVIk9up40sCwS61QaB8SMIHrvxKlgA==
X-Received: by 2002:adf:ff91:: with SMTP id j17mr24155041wrr.5.1568124635747;
        Tue, 10 Sep 2019 07:10:35 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id s9sm4262408wme.36.2019.09.10.07.10.34
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Sep 2019 07:10:35 -0700 (PDT)
Message-ID: <5d77aedb.1c69fb81.dab3b.4f7d@mx.google.com>
Date:   Tue, 10 Sep 2019 07:10:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.143
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y boot: 84 boots: 0 failed, 84 passed (v4.14.143)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y boot: 84 boots: 0 failed, 84 passed (v4.14.143)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-4.=
14.y/kernel/v4.14.143/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.14.y/k=
ernel/v4.14.143/

Tree: stable
Branch: linux-4.14.y
Git Describe: v4.14.143
Git Commit: e2cd24b629389b52a31d96d226ed150dacab9cdd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 39 unique boards, 16 SoC families, 11 builds out of 201

---
For more info write to <info@kernelci.org>
