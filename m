Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5391130B816
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 07:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232213AbhBBGzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 01:55:52 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:42694 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbhBBGzv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 01:55:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1126sBVl026565;
        Tue, 2 Feb 2021 06:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=9EBf4UsWnrYciOb0VmTesjX4QVUYasu/M1Onu9gj/V4=;
 b=CFhaFsntxwyNgdmFPjfKD7XQtqJJKdU+dOzH8GHiZJzb7SfTEDrkyjok32LKXCBa6YI+
 xCHOxbP+nSRoywd9IJcvrGi8tAFXPbwBTt1HV2C0Ymrj+1EKnTAGmskobR6Fu+irzSfi
 Muc78emWGtJHcT5gjeWCTq0BwKIbtwq4DyL8QAtdyqnyCwRrKETdrIBO0UI9TydSDmCe
 xf9baXJ413PiXIE8Nu7AQgltc6IY+iEC9J7CpWnXdhXQ0F/9j0zzo2VlkO9gElHtQ5YS
 2XCSEAbpk1fLgPP0MoWEFFQN786G28/9dKGftW2ULFt0qYHK/67J7ak60s42W9AvLJW+ pQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 36cxvr15sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 06:55:02 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1126su0W017991;
        Tue, 2 Feb 2021 06:54:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 36dhbxsspc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 06:54:59 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1126sneD010423;
        Tue, 2 Feb 2021 06:54:49 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Feb 2021 22:54:48 -0800
Date:   Tue, 2 Feb 2021 09:54:38 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        devel@driverdev.osuosl.org, Masahiro Yamada <masahiroy@kernel.org>,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH] staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c
Message-ID: <20210202065438.GO2696@kadam>
References: <20210130034507.2115280-1-ilya.lipnitskiy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210130034507.2115280-1-ilya.lipnitskiy@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=0
 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020047
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020047
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 07:45:07PM -0800, Ilya Lipnitskiy wrote:
> Also use KBUILD_MODNAME for module name.
> 
> This driver is only used by RALINK MIPS MT7621 SoCs. Tested by building
> against that target using OpenWrt with Linux 5.10.10.
> 
> Fixes the following error:
> error: the following would cause module name conflict:
>   drivers/dma/mediatek/mtk-hsdma.ko
>   drivers/staging/mt7621-dma/mtk-hsdma.ko
> 

The only part of this commit message that I could understand at all was
the parts which were copy and pasted from the build system...  :/
Please, write it like this:

[PATCH] staging/mt7621-dma: fix build conflict

This driver cannot be built because we have two modules with the same
name and it leads to an error:

  error: the following would cause module name conflict:
    drivers/dma/mediatek/mtk-hsdma.ko
    drivers/staging/mt7621-dma/mtk-hsdma.ko

The fix is to rename mtk-hsdma.c to hsdma-mt7621.c.  Also we can use the
KBUILD_MODNAME where appropriate instead of hard coding the name.

regards,
dan carpenter

