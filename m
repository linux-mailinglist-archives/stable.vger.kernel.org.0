Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5782172306
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbgB0QSt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 11:18:49 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:60472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729566AbgB0QSt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Feb 2020 11:18:49 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RG4D1i109811;
        Thu, 27 Feb 2020 16:18:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Txf8TnQig3tuLr/6i8GVUZRZw5RyXpqdmFYnU7NIYz0=;
 b=qnesj0f4TIvukY29pluvHXchUjE4UlzKvEpN52NFKEcRAKQ9IXKkGaqwAcJ6s1w3kcD3
 aTya/OKLWTUHW7PGWIKLaAF67l3yUXCjmcyDC13xoFUIKILeTYD6/y4h13mktyjXq3kh
 OG5SmxT1IwPco8rqIiKNa+jT7pgfnva8wYt2R6m5n8bWEUt3VmoE+GhHDCICC5f+ZKGO
 UerPvySbpOyIzJIkDez9CTcvm3TlreQv3+fMBOd66Aw7/NZZCwXAG39fTIij2Rc6SIiJ
 ZdOofsJRQk5PD8ReD5tRx2qhwpypZqkIqgad6F9k0Kigtj5r56pn0C59jjPhs7PQ28ti eA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ydybcp0kj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 16:18:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01RGEJqv118358;
        Thu, 27 Feb 2020 16:18:41 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ydj4mxve6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Feb 2020 16:18:41 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01RGIcKX013836;
        Thu, 27 Feb 2020 16:18:38 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 27 Feb 2020 08:18:38 -0800
Date:   Thu, 27 Feb 2020 19:18:29 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 5.5 133/150] scripts/get_maintainer.pl: deprioritize old
 Fixes: addresses
Message-ID: <20200227161829.GE3308@kadam>
References: <20200227132232.815448360@linuxfoundation.org>
 <20200227132252.076691216@linuxfoundation.org>
 <dd96f64a5fd44278e48a1f7ee9269c485278d183.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd96f64a5fd44278e48a1f7ee9269c485278d183.camel@perches.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 suspectscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=913 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002270124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9543 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 priorityscore=1501 suspectscore=0 mlxlogscore=962 lowpriorityscore=0
 phishscore=0 spamscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002270124
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 27, 2020 at 07:20:32AM -0800, Joe Perches wrote:
> On Thu, 2020-02-27 at 14:37 +0100, Greg Kroah-Hartman wrote:
> > From: Douglas Anderson <dianders@chromium.org>
> > 
> > commit 0ef82fcefb99300ede6f4d38a8100845b2dc8e30 upstream.
> 
> I think adding just about any checkpatch patch to stable a bit silly.
> Including patches to checkpatch.
> 

On the other hand, Greg is one of the worst affected by the old behavior
since he has so many old email addresses and he's also the stable
maintainer.

regards,
dan carpenter
