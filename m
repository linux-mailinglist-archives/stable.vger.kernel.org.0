Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC4E14167D
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 09:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgARIS2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 03:18:28 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33560 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbgARIS2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Jan 2020 03:18:28 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00I8I4aL127645;
        Sat, 18 Jan 2020 08:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=igDgR4Dxyg/HWSyrKho0QnTzigEnDILlIedKQO8SL+Y=;
 b=Bc47QU+gi3lHki5WpQzcJi6pwRlGFlPaMr5VA++FKKk7TSKPalkjLP+eYrd/ZR+wTJu2
 kbQ7k0zfoChdNpB+ynEvI0dWHyBT4IDO98FsXRg4DYC7vMA/TidQES16iv67eHhKRy4G
 jKc9qYtntAe2mPvVlBnDGc7exL3uEp+7f+UvbhplCYDgo90V9zI4C8c7IXbgzPkAgOwj
 vdnV2EPGMOMMJIVllAbfoznQUjQl2tIRNOL7bM8ZahHcYenioTrcFYdzit+mlFzMKply
 gdChmhP+GsTxL1Qz6RSVU0rZvtPZLHKRL/VGSLo00X//rej68InVy0R3fDFjA5puqkIK bA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2xksyprfw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 08:18:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00I8E7Es077825;
        Sat, 18 Jan 2020 08:16:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2xkq5nbg4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 18 Jan 2020 08:16:17 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00I8GFne011743;
        Sat, 18 Jan 2020 08:16:15 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 18 Jan 2020 00:16:14 -0800
Date:   Sat, 18 Jan 2020 11:18:45 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Greg KH <greg@kroah.com>
Cc:     Steven Price <steven.price@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH AUTOSEL 5.4 002/205] drm/panfrost: Add missing check for
 pfdev->regulator
Message-ID: <20200118081845.GF19765@kadam>
References: <20200116164300.6705-1-sashal@kernel.org>
 <20200116164300.6705-2-sashal@kernel.org>
 <20200117161226.GA8472@arm.com>
 <20200117165909.GA1949937@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200117165909.GA1949937@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001180064
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9503 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1031
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001180065
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 17, 2020 at 05:59:09PM +0100, Greg KH wrote:
> On Fri, Jan 17, 2020 at 04:12:27PM +0000, Steven Price wrote:
> > On Thu, Jan 16, 2020 at 04:39:37PM +0000, Sasha Levin wrote:
> > > From: Steven Price <steven.price@arm.com>
> > > 
> > > [ Upstream commit 52282163dfa651849e905886845bcf6850dd83c2 ]
> > 
> > This commit is effectively already in 5.4. Confusingly there were two
> > versions of this upstream:
> > 
> > 52282163dfa6 ("drm/panfrost: Add missing check for pfdev->regulator")
> > c90f30812a79 ("drm/panfrost: Add missing check for pfdev->regulator")
> > 
> > It got merged both through a -fixes branch and through the normal merge
> > window. The two copies caused a bad merge in mainline and this was
> > effectively reverted in commit 603e398a3db2 ("drm/panfrost: Remove NULL
> > check for regulator").
> > 
> > c90f30812a79 is included in v5.4 so should already be in any v5.4.y
> > release.
> 
> Have I mentioned this month just how much I hate the way the DRM tree
> handles stable patches like this?  This kind of fallout is a pain for
> stable maintainers, I dred every time I see a drm patch tagged for
> stable.
> 
> But we've been over this all before :(

Another example is:

29cd13cfd762 ("drm/v3d: Fix memory leak in v3d_submit_cl_ioctl")
0d352a3a8a1f ("drm/v3d: don't leak bin job if v3d_job_init fails.")

Two fixes for a memory leak were merged so now it's a double free.  I
sent a patch on Jan 10 but no one responded.

regards,
dan carpenter

