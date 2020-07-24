Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 876C822BAEC
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 02:21:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgGXAVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jul 2020 20:21:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54289 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728251AbgGXAVS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jul 2020 20:21:18 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200724002116epoutp046158fc15a1f81e87622fbb5b2f78b3ea~kiFc_F77u1269512695epoutp04W
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 00:21:16 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200724002116epoutp046158fc15a1f81e87622fbb5b2f78b3ea~kiFc_F77u1269512695epoutp04W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595550076;
        bh=bCZ0lxD5UcA/rR5hvGRYnd22iZUfYOAIf3hNu/QJ72s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=ngoZ0eC1FCefGgiWMAXE6GRBgAF6zQvKXHBRb5m23tPAIi3LoEc8+UJhR/Kqh5YEo
         NT/qnSu6cIaygaGDDMoq5YR3frucffIyE7uAzqIk6aHf0vXt9jwIeh4df/l4MBSlU9
         5e9DjzklYe8T5WXaUqD+tSEo1f0DOa/+Rp/8ZrgA=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200724002115epcas1p2f1c3caba874a72aea4415028b285082f~kiFcTfhms0453404534epcas1p2I;
        Fri, 24 Jul 2020 00:21:15 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.159]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4BCVHH04jgzMqYkV; Fri, 24 Jul
        2020 00:21:15 +0000 (GMT)
Received: from epcas1p1.samsung.com ( [182.195.41.45]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        F8.76.19033.9792A1F5; Fri, 24 Jul 2020 09:21:13 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002112epcas1p24c54808617a5baddef4e4a2f49722866~kiFZ5CvcH0186801868epcas1p2D;
        Fri, 24 Jul 2020 00:21:12 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200724002112epsmtrp26ac8255c3df7eeb9c17c2c0436c9e2b5~kiFZ4X_Rt3166431664epsmtrp2D;
        Fri, 24 Jul 2020 00:21:12 +0000 (GMT)
X-AuditID: b6c32a36-159ff70000004a59-39-5f1a29793420
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        C2.88.08382.8792A1F5; Fri, 24 Jul 2020 09:21:12 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200724002112epsmtip2a8965ae73cef18e4af7d3496da2cb477~kiFZttCSl0534305343epsmtip2T;
        Fri, 24 Jul 2020 00:21:12 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 0/4] exfat stable patches for 5.7.y
Date:   Fri, 24 Jul 2020 09:15:40 +0900
Message-Id: <20200724001544.30862-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsWy7bCmrm6lplS8wZXPOhbNi9ezWfyYXm+x
        ac01NosFGx8xOrB4bFrVyeaxf+4ado++LasYPT5vkgtgicqxyUhNTEktUkjNS85PycxLt1Xy
        Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3synKLy1JVcjI
        Ly6xVUotSMkpMDQo0CtOzC0uzUvXS87PtTI0MDAyBapMyMnY9/8Hc8EOloq2qxOYGxjXM3cx
        cnJICJhIPJn1jK2LkYtDSGAHo8THNXOZQBJCAp8YJW4eEoJIfGOUuHjnN0sXIwdYx9l9zBDx
        vYwSzbdvMsM1THjMCVLDJqAt8WeLKEhYRMBQ4sbna2CtzAKOEjvu8YGYwgKWEhN+l4NUsAio
        Ssw/1MsKYvMK2Ehc3dvKCnGavMTqDQfANkkIdLNLHDo+nwUi4SLxdh3M/cISr45vYYewpSQ+
        v9vLBnFltcTH/VAlHYwSL77bQtjGEjfXb2CFuEZTYv0ufYiwosTO33MZQWxmAT6Jd197WCGm
        8Ep0tAlBlKhK9F06zARhS0t0tX+AWuohMfXtDUZIEMRK7Lu1nGUCo+wshAULGBlXMYqlFhTn
        pqcWGxYYIUfPJkZw+tEy28E46e0HvUOMTByMhxglOJiVRHh1GMXjhXhTEiurUovy44tKc1KL
        DzGaAoNrIrOUaHI+MAHmlcQbmhoZGxtbmJiZm5kaK4nz/jvLHi8kkJ5YkpqdmlqQWgTTx8TB
        KdXAVGA5W/GJQ470bfEFaVvu54Y0THjhuVvt82NpB0bW3PSJXRfW3f90au/36Sn95R26PlN2
        zLUK35o4+UXCtH+nLHvK7SyPnz2zOasqdGnPfo7boU+vTtlm3lQvzDIhJ6X70ba2eb1XZzmm
        mmaFX6s7PFGdKX1266ZG+WUeqw4K2sx+1/Cjjv2XaMbH6lspPvqr8hTC4mzUr01NbeW1uxpy
        dxffpi1rLyTy7eOYfc37fcX3xKqp639sSLm9eu1h3a2Sykd/rPde9/NM0fOu2kf77DbwN1vr
        MV5Y39/BZft4nkz6BftXz3mZ1t+IY/mqdCzxxI42zQfJm8sdFA33PeFcXtE879fzODFRbXHJ
        S1eXqSmxFGckGmoxFxUnAgAwDeITyAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsWy7bCSvG6FplS8wevn5hbNi9ezWfyYXm+x
        ac01NosFGx8xOrB4bFrVyeaxf+4ado++LasYPT5vkgtgieKySUnNySxLLdK3S+DK2Pf/B3PB
        DpaKtqsTmBsY1zN3MXJwSAiYSJzdB2RycggJ7GaUOPs5H8SWEJCWOHbiDFSJsMThw8VdjFxA
        JR8YJVb+amIBibMJaEv82SIKYooIGEu0fy0DMZkFnCXerxADMYUFLCUm/C4HmccioCox/1Av
        K4jNK2AjcXVvKyvEHnmJ1RsOME9g5FnAyLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93
        EyM4HLQ0dzBuX/VB7xAjEwfjIUYJDmYlEV4dRvF4Id6UxMqq1KL8+KLSnNTiQ4zSHCxK4rw3
        ChfGCQmkJ5akZqemFqQWwWSZODilGpjKLpjefXv0YeaPVT5JKyaw9D7rP+KXa/OO25lz34xi
        jzXW1QX51y3XCbvl1Lk9Wnjb5NFqS8Y7FtUyht+mu549lmcx78rr7ECVRzwx4myp26Yd5S9f
        1HN42gS32UKr5x7z0A/YPdHzzv4fNXf2pju8mWsRofi4bNFz48MPW5+fmFh5VWFdwerwlX95
        00/KG5e18HV/3q/ezOTAuaFPpqB2zt80hejCoyKtW+YfjTnCKrn6wDbDXob73/eEHVw607Xj
        Ztsswz9XjVdUn/D+Gp3v+dZg8oSz0wy5K879q7RbKrijKJGve7m7rkJqmornl8+c/q03FB9f
        uWOcU9mwX8RjU31jlGtoddQq1QLlDYVKLMUZiYZazEXFiQCX20/ydgIAAA==
X-CMS-MailID: 20200724002112epcas1p24c54808617a5baddef4e4a2f49722866
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200724002112epcas1p24c54808617a5baddef4e4a2f49722866
References: <CGME20200724002112epcas1p24c54808617a5baddef4e4a2f49722866@epcas1p2.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Could you please pick up exfat stable patches ?

Thanks!

Hyeongseok Kim (1):
  exfat: fix wrong size update of stream entry by typo

Ilya Ponetayev (1):
  exfat: fix name_hash computation on big endian systems

Namjae Jeon (2):
  exfat: fix overflow issue in exfat_cluster_to_sector()
  exfat: fix wrong hint_stat initialization in exfat_find_dir_entry()

 fs/exfat/dir.c      | 2 +-
 fs/exfat/exfat_fs.h | 2 +-
 fs/exfat/file.c     | 2 +-
 fs/exfat/nls.c      | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

-- 
2.17.1

