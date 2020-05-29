Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 677701E8659
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 20:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726549AbgE2SLz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 14:11:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39842 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgE2SLz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 14:11:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TI7rC7138010;
        Fri, 29 May 2020 18:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=/fyvsjFoPsbkA1GVuN/dI2b6nc/iceLQHQFPArQrilE=;
 b=LTPz570UgTigVYVLhdYR9nC/k/QfglpiCd6UsRBGQ3C7511Gfowvk80eL8Yo0eHBxhWR
 f1QZQC7R36ky3T0lMun9xEVViJxx0Volp2tX4Q604pvBFnuJSYotmvPrwKkVlxOI7JtL
 jfCUC6AW8qJhinhcoCS6nv+BTl/o3RXfkul4B/Z1ArTseOhI+VWHEZ6kAYR5Lt+0FkY0
 Q617M+sWzmo77gIkDXnF0RZaBZsPdjjwYTU+OI/URu7EQQtiFcuxIqE0BzKQyhVye9oK
 fGdJUvjaCKbkC6UWQEijuFuq0OUaAZXzq0KuXjSeKa8d1TjTXQMj1OB0+SzRB/B6kzLl Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 318xbkbu8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 29 May 2020 18:11:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04TI91Yu080640;
        Fri, 29 May 2020 18:11:52 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 317ds4mu88-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 18:11:52 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04TIBpJk009285;
        Fri, 29 May 2020 18:11:52 GMT
Received: from revenge.us.oracle.com (/10.135.188.124)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 29 May 2020 11:11:51 -0700
Date:   Fri, 29 May 2020 18:09:43 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.4] bcache: initialize 'sb_page' in register_bcache()
Message-ID: <20200529180943.ifijafwdjudflw34@revenge.us.oracle.com>
References: <041443374fde130be3bc864b6ac8ffba6640c2b0.1588184799.git.tom.saeger@oracle.com>
 <20200430064421.GF2377651@kroah.com>
 <20200501011318.pwcjic2jsvotxebd@revenge.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501011318.pwcjic2jsvotxebd@revenge.us.oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 adultscore=0 suspectscore=1 bulkscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005290137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9636 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 cotscore=-2147483648
 suspectscore=1 bulkscore=0 clxscore=1015 impostorscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005290137
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 01, 2020 at 01:13:19AM +0000, Tom Saeger wrote:
> On Thu, Apr 30, 2020 at 08:44:21AM +0200, Greg KH wrote:
> > On Wed, Apr 29, 2020 at 06:38:17PM +0000, Tom Saeger wrote:
> > > commit 393b8509be33 (bcache: rework error unwinding in register_bcache)
> > > 
> > > introduced compile warning:
> > > warning: 'sb_page' may be used uninitialized in this function [-Wmaybe-uninitialized]
> > > 

FWIW - 8f6a84167e86 (Stop the ad-hoc games with -Wno-maybe-initialized)

successfully squelched the warning I previously reported.  Still shows up with W=2
for me on FC31 (gcc9.3.1), but this is probably moot at this point.

--Tom
