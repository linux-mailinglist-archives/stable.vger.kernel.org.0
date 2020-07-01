Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3FD211696
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 01:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgGAXZk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 19:25:40 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:40403 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbgGAXZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 19:25:40 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200701232537epoutp0139bf6edc22fe3bbf8b233b13097eccc8~dxIlS06L_1645816458epoutp01t
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 23:25:37 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200701232537epoutp0139bf6edc22fe3bbf8b233b13097eccc8~dxIlS06L_1645816458epoutp01t
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593645937;
        bh=To6Qa4MXv1vIe/oZatIOPnmiOSPIUwt9HcTsHPPllos=;
        h=From:To:Cc:Subject:Date:References:From;
        b=Zs+5XUPBf7KcUjMvEYHRyezn+EVQu0BVz7QGEsBkXRdx7hsH1AztPk25Lk49N2s9U
         NCswtmFiOjGUWOd1W40GyqQxYixan38nH8XoFnvo7axMfvv8BP0Ovfg1Nq3g5rdXui
         QjLgx1PQG5hqhwKTs0GDXeSTRPiMW89wYpXevnIQ=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTP id
        20200701232536epcas1p36124df03e50d7dc7c85ac9f722f5d1e6~dxIlBicLi0140501405epcas1p33;
        Wed,  1 Jul 2020 23:25:36 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.166]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 49xy5D2TMQzMqYkZ; Wed,  1 Jul
        2020 23:25:36 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        B3.BB.29173.07B1DFE5; Thu,  2 Jul 2020 08:25:36 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p3.samsung.com (KnoxPortal) with ESMTPA id
        20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac~dxIj6Eh0B0140501405epcas1p3t;
        Wed,  1 Jul 2020 23:25:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200701232535epsmtrp15987d5f99e1e169ff6f1e259b9f372dc~dxIj5ZZEm1659116591epsmtrp1_;
        Wed,  1 Jul 2020 23:25:35 +0000 (GMT)
X-AuditID: b6c32a37-9b7ff700000071f5-cd-5efd1b7047fc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        30.AE.08303.F6B1DFE5; Thu,  2 Jul 2020 08:25:35 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200701232535epsmtip2673fb550dbeb5c86a3245d85d50eb058~dxIjtbhKL2776827768epsmtip2b;
        Wed,  1 Jul 2020 23:25:35 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH 5.7.y 0/5] exfat stable patches for 5.7.y
Date:   Thu,  2 Jul 2020 08:20:19 +0900
Message-Id: <20200701232024.2083-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLKsWRmVeSWpSXmKPExsWy7bCmvm6B9N84gydrhSyaF69ns7i8aw6b
        xY/p9Rab1lxjs1iw8RGjA6vHplWdbB77565h9+jbsorR4/MmuQCWqBybjNTElNQihdS85PyU
        zLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKC1SgpliTmlQKGAxOJiJX07m6L8
        0pJUhYz84hJbpdSClJwCQ4MCveLE3OLSvHS95PxcK0MDAyNToMqEnIwr85+yFtxlrfj3ew5z
        A+MOli5GTg4JAROJWdu7WLsYuTiEBHYwSuxqW8gG4XxilHjf9ZgJwvnMKDFh1QS4lvlHTjJC
        JHYxSsyesRShZcWPa0AOBwebgLbEny2iIA0iAoYSNz5fYwEJMwskSpzf6woSFhawlHjavowJ
        xGYRUJV4M3EWmM0rYC3Rc3ApO8QueYnVGw4wg4yXEJjOLnH/4z1GiISLxN5396EOEpZ4dXwL
        VIOUxMv+NnaQXRIC1RIf9zNDhDsYJV58t4WwjSVurt/ACnGOpsT6XfoQYUWJnb/ngk1nFuCT
        ePe1hxViCq9ER5sQRImqRN+lw0wQtrREV/sHqKUeEneX7wNbKiQQKzFtu/EERtlZCPMXMDKu
        YhRLLSjOTU8tNiwwRo6hTYzgdKRlvoNx2tsPeocYmTgYDzFKcDArifCeNvgVJ8SbklhZlVqU
        H19UmpNafIjRFBhaE5mlRJPzgQkxryTe0NTI2NjYwsTM3MzUWEmc19fqQpyQQHpiSWp2ampB
        ahFMHxMHp1QD081zSlOupBWwbYn1CfjNOWli/TwZCx32d2kex8Sqak5x++12fHrMQPzes7KT
        V5jni8xW+rtsZ/edkAtct6c+XDMlQ3K7soboh4np7c5zp2p89df4rxhvwLBK6kr5hb0vux6Z
        RjWxZQrUCNva7b5s+sJa0f235c31YnzpyXJu35dNT1/buLY/IMDv2Pe1C18XLTia86Tu5J+3
        Vw8Zdwn/qPeZkLPilfRVj64LiX+dl1zdcrp8j2zeopA7Ev/utc1irEku51Wulp3R2nHus+On
        xQwHWM7MsYqJ3evo6N/5uc3YVSz8vZTYB/tZTF8/n7m8Nf1X8XOBxYomUvbhG6eWqjiJfb0p
        J1n75pThGeeL7UosxRmJhlrMRcWJAK+aBF/QAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNJMWRmVeSWpSXmKPExsWy7bCSvG6+9N84g78nNCyaF69ns7i8aw6b
        xY/p9Rab1lxjs1iw8RGjA6vHplWdbB77565h9+jbsorR4/MmuQCWKC6blNSczLLUIn27BK6M
        K/OfshbcZa3493sOcwPjDpYuRk4OCQETiflHTjJ2MXJxCAnsYJTYPucbI0RCWuLYiTPMXYwc
        QLawxOHDxRA1HxglXvW0sYPE2QS0Jf5sEQUxRQSMJdq/loGYzALJEvv3WoAMERawlHjavowJ
        xGYRUJV4M3EWmM0rYC3Rc3ApO8QieYnVGw4wT2DkWcDIsIpRMrWgODc9t9iwwCgvtVyvODG3
        uDQvXS85P3cTIzg8tLR2MO5Z9UHvECMTB+MhRgkOZiUR3tMGv+KEeFMSK6tSi/Lji0pzUosP
        MUpzsCiJ836dtTBOSCA9sSQ1OzW1ILUIJsvEwSnVwGS3Ovr8BvVdr8+9+Hl8zn77M486XWV9
        Ds28vVJxxU3WximHLj7cETZL7u9M61WzPwhyz7/2aL7Yb9aWa0Ec/863dDoFZDaWn6n6qZtw
        o3mnwd/Vvy4V7zrkEa/jwmHzxHijzdWPe1cvXmrmwsJmpyxQb7b5r8v0oD6uV0JlgRyvU+Id
        dsc+6DrvrjH33TWmT5vEmp7O/dbUE/C9RfvyM5Y31i/TD59fGLb/Y8lKmUnrv2/QXCBhub0v
        kf3O731P5/jf2bhmAz/D1uDa9uc3Sy6+XV2tN+VrbtDPusVsnSvWSe68tEVVZALrJEf+i8+O
        9hd11gZkydwI7f0QWmaeUr91YcIN5YlzvBi/Ke7peLK3TImlOCPRUIu5qDgRAL1Ps3l+AgAA
X-CMS-MailID: 20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac
References: <CGME20200701232535epcas1p3787fa9426c087372556cba2fdb7232ac@epcas1p3.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Could you please push exfat stable patches into 5.7.y kernel tree ?

Thanks!

Dan Carpenter (1):
  exfat: add missing brelse() calls on error paths

Hyeongseok.Kim (1):
  exfat: Set the unused characters of FileName field to the value 0000h

Hyunchul Lee (1):
  exfat: call sync_filesystem for read-only remount

Namjae Jeon (1):
  exfat: move setting VOL_DIRTY over exfat_remove_entries()

Sungjong Seo (1):
  exfat: flush dirty metadata in fsync

 fs/exfat/dir.c      | 12 +++++++-----
 fs/exfat/exfat_fs.h |  1 +
 fs/exfat/file.c     | 19 ++++++++++++++++++-
 fs/exfat/namei.c    | 14 +++++++++++---
 fs/exfat/super.c    | 10 ++++++++++
 5 files changed, 47 insertions(+), 9 deletions(-)

-- 
2.17.1

