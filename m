Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6BE133324
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 17:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729199AbfFCPJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 11:09:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32881 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729077AbfFCPJa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 11:09:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id n9so42428wru.0
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 08:09:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=Vqm1HfyKlx7kXvXfV/7917TkSslzuRGRJYlsCpZ14dM=;
        b=fHnCkh64opjMDENTgwjQ13bgW0T+1YoOzZowkcdkniBNVXm8aGFQDtJj4HlKZKRAFU
         hN6AEfR1z1NueaPGflcdbBVgeDT0UggM8NP4ipfGyaYPuZO2XQtuwnfEomt/a8JcL3sN
         jB2mKZ1hk93hJUcZQDMUMa+Tav97VD1OKkWSVhCTGPaZLxJiJ1lBtpnwFJQvTyOPjeIW
         DtcgPKo56GFWK7+yvS/Yr3EH418gsFv8dxe3nXW3JquC39gPHz+GSJir8Voot3XO30ee
         FCquu6dmUxV3rmTMp7TGefhnBkLW9ePQFiZn3LtpQzSv4PRUX0+f6EwXS/XvgG9vjWif
         OsyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=Vqm1HfyKlx7kXvXfV/7917TkSslzuRGRJYlsCpZ14dM=;
        b=dQKH/weEeuO81O4cqTV+j/M4bcZbIkZR8goDt8RKpLKKrw3zJOUomNhMw42yOw2O3B
         F40LeWQE4Vf2ljUdZ/I/BY/XtilOC/cHm/IBDhlWOUYs5JYNArhZMA8kwOOUEaElR594
         e9DlNahRjIOVCnszF7VUCiTAu+/4xLXZh6G06ms6FOahtnb/JV8R0vjYPXvDDCAoI4Dh
         1x8IA5TbdkIIOI5GDyBBZod39bnoeup9v+6dvXBeWTW2Z9jydOiGGiTuhqt0lYUb/CrR
         T2g2bLZF76yBcZ56WB8TUHpPk1OP25dBs+8vhSfHC+8A0dok2PPXXQNMYXl1SIdkfInM
         gRHw==
X-Gm-Message-State: APjAAAWWTOb2d243XaTarC5k2qCDXA0CK09dOaXIiYNSnAPqd5fYyCX3
        DZLNIpLgGoo6+/L0iY12iD5+Gg==
X-Google-Smtp-Source: APXvYqwU0lVglIFJfMRaSFftIxmyAjZdMht92axgOZOB37s5N3QdzwpNosqv4p6DZN+PAalximQWFw==
X-Received: by 2002:adf:9791:: with SMTP id s17mr2904169wrb.274.1559574568930;
        Mon, 03 Jun 2019 08:09:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 65sm30009471wro.85.2019.06.03.08.09.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 08:09:28 -0700 (PDT)
Message-ID: <5cf53828.1c69fb81.8054a.1e80@mx.google.com>
Date:   Mon, 03 Jun 2019 08:09:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.47-33-g322f4070727b
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
In-Reply-To: <20190603090308.472021390@linuxfoundation.org>
References: <20190603090308.472021390@linuxfoundation.org>
Subject: Re: [PATCH 4.19 00/32] 4.19.48-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 126 boots: 0 failed, 126 passed (v4.19.47-33-g=
322f4070727b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.47-33-g322f4070727b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.47-33-g322f4070727b/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.47-33-g322f4070727b
Git Commit: 322f4070727b6cedd9f682203efe5b910b4daceb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 23 SoC families, 14 builds out of 206

---
For more info write to <info@kernelci.org>
