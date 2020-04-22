Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1F41B468C
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 15:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgDVNq2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 09:46:28 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49776 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgDVNq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 09:46:28 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MDiRxo083787;
        Wed, 22 Apr 2020 13:46:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZXw8WRe+1+ti8NtxJ2Zt9aajNxmS/04DjrSxbrXEJSY=;
 b=UDJE3DnjdTKCLTPXwmaquXLFx/ie8LIs87/gEGhh9Fr81ijDF4YE8tb6gd8wYWfXcDuW
 S14UiZwraIIXAPDj/N3HTmwu7qI+SvKWsEwtg76gqaoAAtR4JYA+Dej45W/gpHdjivbI
 iVHaLBOfY4Tm8OfvC30Yfu00VRnUDBHbqOcsYN8ltM9oXe9DkXSd3/zD2zW+X8Ci9gRF
 JeX9HvSEpOlKqIICksED5JC1ma9u8fJMP77xtGO9fxmRJ7319YDcrotnJ3DfvEqfMCZw
 n9uhKH6+rIFR4Sr1JkpTDSHE+B41703TAJSdoHM9be/1A5i+EavX6hU2qjmfn0+u+Com Ww== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30grpgqby8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 13:46:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MDfddP112936;
        Wed, 22 Apr 2020 13:46:15 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 30gb3ty429-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 13:46:15 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03MDkDa9032313;
        Wed, 22 Apr 2020 13:46:14 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 22 Apr 2020 06:46:13 -0700
Date:   Wed, 22 Apr 2020 09:46:35 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] padata: add separate cpuhp node for CPUHP_PADATA_DEAD
Message-ID: <20200422134635.dk44a4zy2rz6p3d3@ca-dmjordan1.us.oracle.com>
References: <20200421163455.2177998-1-daniel.m.jordan@oracle.com>
 <20200422132702.DCAA7206EC@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422132702.DCAA7206EC@mail.kernel.org>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 adultscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220110
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220110
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 01:27:02PM +0000, Sasha Levin wrote:
> Hi

Hi!

> v5.4.33: Failed to apply! Possible dependencies:
>     bfcdcef8c8e3 ("padata: update documentation")

Yes, it's a trivial conflict in the header comment for padata_instance.

> How should we proceed with this patch?

If mainline is ok with the change, I will send a 5.4-only version with the
resolution.

By the way, I should not have cc'd stable on the email, it was picked up from
the Cc: line in the patch.

Daniel
