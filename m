Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 416071DA1C9
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbgESUAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 16:00:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:35822 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728396AbgESUAK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 16:00:10 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JJvO3X163391;
        Tue, 19 May 2020 19:59:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=KFT7il4oQYnxSD//NHfbPGAV55evT6o96B02J2kbkZc=;
 b=m5Pfir0j+8jvBAJNVLO6/UwXRLk5AYrLZOIA3N/vmvP6+bYmnxX096KKmNhNUMSf/5x4
 0V2v6IPkBJ9bHq2Tyr+WvMy6gIsRiBdLXV3TYjQLdogQlzLzC+AdEuOoRFsbxPKzQR5U
 r8N/tvlD/nj3Ke3YWsbbWKXxwTRrW/+HG1G9hN5z3uBVpvsyzapUZ0f++Sx/ZtbgMdUw
 KtYmSlx1NAJ53rZPD+B1O4oNyPFZLDO5W9pI8f5wFn1NwQqa3fcb+0kdH61esQrH+6v8
 jmxxmkvDJg4gbvcqpeUsJcCWWtILAUgjwitg4uVVVcVwz3l6Ihph5dShOfG/xHnf4gcF ZQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 3128tnffh0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 19 May 2020 19:59:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04JJx1AG115652;
        Tue, 19 May 2020 19:59:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 312t3586n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 May 2020 19:59:56 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04JJxsP2028706;
        Tue, 19 May 2020 19:59:55 GMT
Received: from ca-dmjordan1.us.oracle.com (/10.211.9.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 May 2020 12:59:54 -0700
Date:   Tue, 19 May 2020 16:00:18 -0400
From:   Daniel Jordan <daniel.m.jordan@oracle.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Backporting "padata: Remove broken queue flushing"
Message-ID: <20200519200018.5vuyuxmjy5ypgi3w@ca-dmjordan1.us.oracle.com>
References: <0b158b60fe621552c327e9d822bc3245591a4bd6.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b158b60fe621552c327e9d822bc3245591a4bd6.camel@decadent.org.uk>
User-Agent: NeoMutt/20180716
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=968
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=2 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005190170
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9626 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 bulkscore=0 spamscore=0
 clxscore=1011 cotscore=-2147483648 suspectscore=2 lowpriorityscore=0
 adultscore=0 phishscore=0 mlxlogscore=990 mlxscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005190170
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Ben,

On Tue, May 19, 2020 at 02:53:05PM +0100, Ben Hutchings wrote:
> I noticed that commit 07928d9bfc81 "padata: Remove broken queue
> flushing" has been backported to most stable branches, but commit
> 6fc4dbcf0276 "padata: Replace delayed timer with immediate workqueue in
> padata_reorder" has not.
>
> Is this correct?  What prevents the parallel_data ref-count from
> dropping to 0 while the timer is scheduled?

Doesn't seem like anything does, looking at 4.19.

I can see a race where the timer function uses a parallel_data after free
whether or not the refcount goes to 0.  Don't think it's likely to happen in
practice because of how small the window is between the serial callback
finishing and the timer being deactivated.


   task1:
   padata_reorder
                                      task2:
                                      padata_do_serial
                                        // object arrives in reorder queue
     // sees reorder_objects > 0,
     //   set timer for 1 second
     mod_timer
     return
                                        padata_reorder
                                          // queue serial work, which finishes
                                          //   (now possibly no more objects
                                          //    left)
                                          |
   task1:                                 |
   // pd is freed one of two ways:        |
   //   1) pcrypt is unloaded             |
   //   2) padata_replace triggered       |
   //      from userspace                 | (small window)
                                          |
   task3:                                 |
   padata_reorder_timer                   |
     // uses pd after free                |
                                          |
                                          del_timer  // too late


If I got this right we might want to backport the commit you mentioned to be on
the safe side.
