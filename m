Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F5BB89B0
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 05:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405721AbfITDTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 23:19:44 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40865 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406278AbfITDTo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Sep 2019 23:19:44 -0400
Received: by mail-wm1-f68.google.com with SMTP id b24so650153wmj.5
        for <stable@vger.kernel.org>; Thu, 19 Sep 2019 20:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=waLXcJR0MnGH+J0ksYnKyGL1oEhoforOspZHaRd7yEU=;
        b=D11uHMYnAmmc7syykmGAgKusJ2uBjroZgCrCHvc0pgVYywZzPAi7zR9+nbXnW0eaKO
         b+GvGOcUmzzJOxkkVdcr8sDdRl+zO/8bJtzrMzfXhskQxzCTI/Elu9Y4TadrQrESft+G
         VnjT4cjPOFAOjlCoYv19c+f9gSJxc66tumXdV8r1eIlFvznOtBGSu0wmd5Bs++ZlWECq
         pMt6xS/+Cmxsu9VLb7t6TeXU096ffcxiXfPRRjLJG1TXeyT1G1VvZ5kpweyBPZD4OK9B
         1ph1Em89JA1M2KSX8eW2ez4PO/u91prePDd4UynTyxHtWct5f6ePD1HskycUKUpS3DQD
         ZQaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=waLXcJR0MnGH+J0ksYnKyGL1oEhoforOspZHaRd7yEU=;
        b=BbmJS07R2rvkG2pVtOoEGmzGkxBz1KKgHs7lRfsRtGUpdBU5bmw5lfjL5Lw2BZEgAl
         zKI4NzDZ8CnVsuIOWm6ys6p8POgVgb840mwCZYzSWENybcroDXJbbsPlkwfRd/RjpTRm
         3B/XTifpstV20q5L/EijmQDV1GTAF2sxDPOZM6wqoicaDDndASfPzf4WFgCkq6IgknzR
         7JXQOoYnoyoDviY/2ktUqq5bFBdOfUwugVw7uLAQVOWg+0HBYKuWpZvE3LybuibFDcao
         lOqov/Gjg7Kp2QU/BO4zc0QTTsIaHvzRJlXbuIxf1AKZYF2NCTkJZNMtVFqELkT3PDkF
         w7og==
X-Gm-Message-State: APjAAAVHga2FPqDA+9cpNwpsmPvimQSzQMn4YUTpewzc1nQSLX2rBbEs
        GMewFVQn1wt11sJJcVlJpkg+gg==
X-Google-Smtp-Source: APXvYqxChL6xdim29b2yAZCnRM9SfgPdyGIKCph4veIJvDRL52fi1uhEEMQ5WVrvB7p57SUR95rYvw==
X-Received: by 2002:a7b:c44e:: with SMTP id l14mr1134742wmi.54.1568949580592;
        Thu, 19 Sep 2019 20:19:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y14sm726913wrd.84.2019.09.19.20.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2019 20:19:39 -0700 (PDT)
Message-ID: <5d84454b.1c69fb81.46e54.2a65@mx.google.com>
Date:   Thu, 19 Sep 2019 20:19:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.145-60-g981030d9563c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
In-Reply-To: <20190919214755.852282682@linuxfoundation.org>
References: <20190919214755.852282682@linuxfoundation.org>
Subject: Re: [PATCH 4.14 00/59] 4.14.146-stable review
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

stable-rc/linux-4.14.y boot: 65 boots: 0 failed, 65 passed (v4.14.145-60-g9=
81030d9563c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.145-60-g981030d9563c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.145-60-g981030d9563c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.145-60-g981030d9563c
Git Commit: 981030d9563ce66bc738ff8fee0ed8c81922904b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 15 SoC families, 10 builds out of 201

---
For more info write to <info@kernelci.org>
