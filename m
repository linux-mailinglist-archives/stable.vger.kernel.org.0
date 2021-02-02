Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4DA30B9FB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 09:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhBBIcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 03:32:42 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41158 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232200AbhBBIcc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 03:32:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1128UA5f066622;
        Tue, 2 Feb 2021 08:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=oIfbpz0xmZ7wQQosULePV3bybgc6voxs7fjFiYNNtzs=;
 b=xJSI4BdlrI/Fy3XPaq0piYgsRCS20+qsVX52irOIW17UvcxIIIhG98sIilU+usSstcyb
 X1gw5EHEZAsPvKtsJgLBDYLK3VwmyxFLk/9rRkBlKpLm+9AHozqBdHsDoKJxpAd9yCbH
 rArapHX1PoYKErqPn7xRqbHTh1sOdsFlBDR//C5VMKE7KtfPbYjKRMY9CWS+xBftvKoA
 7FS0nxPWn57QsaF+dKRiIoIC0z6N23Bfi4X3bPSuIni2IQfRnn0SlEgdVaHYhIsyaMY9
 r+JYGvXKD2spcZmV9TwI/jgYwf79nGntS4lbxNuJCybWGG2L6W/5Vne/1v6qrsjMF2cd Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 36cxvr1gv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 08:31:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1128QX5P134406;
        Tue, 2 Feb 2021 08:31:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 36dhcw9qdv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 02 Feb 2021 08:31:27 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 1128VPg6024208;
        Tue, 2 Feb 2021 08:31:26 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Feb 2021 00:31:24 -0800
Date:   Tue, 2 Feb 2021 11:31:17 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
Cc:     devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masahiro Yamada <masahiroy@kernel.org>, stable@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH] staging/mt7621-dma: mtk-hsdma.c->hsdma-mt7621.c
Message-ID: <20210202083117.GS2696@kadam>
References: <20210130034507.2115280-1-ilya.lipnitskiy@gmail.com>
 <20210202065438.GO2696@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202065438.GO2696@kadam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 phishscore=0
 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020058
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9882 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102020058
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Apparently this was already merged?  Never mind then.  Once it's merged
it can't be changed.  No big stress...

regards,
dan carpenter

