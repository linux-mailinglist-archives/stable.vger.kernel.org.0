Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAE58CD93D
	for <lists+stable@lfdr.de>; Sun,  6 Oct 2019 22:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726000AbfJFUrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Oct 2019 16:47:42 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35265 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725865AbfJFUrm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Oct 2019 16:47:42 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so12865330wrt.2
        for <stable@vger.kernel.org>; Sun, 06 Oct 2019 13:47:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GwUSuHYrL1JwCOhHzO8rUcAua3B4f9vpjfYKnZkMoz8=;
        b=hFJZHl3E2ntlyWXu73jOsLZOuBjDmhdpmB+wA8KV1iWtBB+wGqj1w/nKc8/vom6XLU
         tov6GhisvAUJxDBolhCnLOoQ+omRgTMvdK+fyehnP6UB9/oz67eHiqLlmuh4GSeZFiWj
         eN2Rl03jHAmTjCBQssKpBEYSlv7UO4L9vK/TMXnR7PS2ZOVOaJoh9ibZ3UngJPFd9V2b
         pmuTzbvb9JLOTOqWB64rZRorvfNjqwDSClXcdsbuTjM66BnV/Cxmdif+nF2lZ5aT4c7o
         r7FZO8DiffZUQB8A55Txr93EjHlpozVo1hiH8VRAuGakL+ydvt1tYBgbvwo3k0veSf6F
         64WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GwUSuHYrL1JwCOhHzO8rUcAua3B4f9vpjfYKnZkMoz8=;
        b=R2KpMeroPnq+HLAMDQZtVtfQ0/St2JSDxsGiFj61MGOTKgdAM+6Z0vTp+s6artfVoj
         Mff5FsiOadr1G9N91t/TCpz9qV1HK/wjtwj8lVKIpcgDVmHfw33xcYKIILepI+HkvbS9
         gChw5s3Yn295stYMeZNYL0Th1lsNtBtefIjLFV4rGdRUEQ6Y/yS+fErNCpT+dmp40qPU
         JNwgSAIURYvedvl/5LWBR6EggQZ+xxxQQVJThXWowguOphpZ0SvOJE9VxRCerp9KPBQI
         DJuTb5EI0JXey1zPv7WNkWSO1G231kL1PqCpKaWX3Hhq4S/vmHJiw2BGupffI1VOrYU5
         IU7Q==
X-Gm-Message-State: APjAAAWtN+Wb1NCwgDkS9/QmcCe9qd4aHuD8I80HpJxU+6ScIYNUfBD3
        AYPwwVvJ7uvTe/Wh3O0OzXW0X78vwmU=
X-Google-Smtp-Source: APXvYqyFLtwkdyqI3Fs8hfyGx7HsNEB7HjOpQpTzJN3G4wnsAdeQxSpbOQqxGfNJpt+VSmoSmJDc5Q==
X-Received: by 2002:a5d:61c5:: with SMTP id q5mr8820005wrv.124.1570394860100;
        Sun, 06 Oct 2019 13:47:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 79sm20074565wmb.7.2019.10.06.13.47.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 06 Oct 2019 13:47:39 -0700 (PDT)
Message-ID: <5d9a52eb.1c69fb81.fdc91.b792@mx.google.com>
Date:   Sun, 06 Oct 2019 13:47:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v5.2.19-133-ga4c5f9f59786
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 38 boots: 0 failed,
 38 passed (v5.2.19-133-ga4c5f9f59786)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 38 boots: 0 failed, 38 passed (v5.2.19-133-ga4c=
5f9f59786)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.19-133-ga4c5f9f59786/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.19-133-ga4c5f9f59786/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.19-133-ga4c5f9f59786
Git Commit: a4c5f9f59786410c2222903600d89f36441b7236
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 30 unique boards, 15 SoC families, 11 builds out of 209

---
For more info write to <info@kernelci.org>
