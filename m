Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1312F396DC1
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 09:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFAHK5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 03:10:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45834 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229984AbhFAHK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 03:10:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15170Lx5016210;
        Tue, 1 Jun 2021 07:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4ST28IwYz90gVL1cDcB7EqsdqKMbuPEsQECPnAteKkU=;
 b=TGjUd6w/49jyRCxTGw69gt0cob5EL+EaHHreqIS9GKqJZo/GOqoAmcQ/bUVv531FD/oZ
 FI1/Lmz8WPHERIZK6OIfQytwbamjwjJO95j5fi8/QdPRjaETzNOwhcD18uV2WDF0u/wT
 aB31NdNlsgWuGzIMo80mC7SsmiKA6klpc5hEsjgrg6SifYQoH+B3e1jD2UawNS2XSbGR
 2G7h8fRDccV9qofYJBWvoeQAooNdJm7GjJM4cRfBbT1YsbHBUxrO5FIQ6dTgix6pJS/f
 AHlzdRQRR6EqRCLTE8M+g4+sf2ps8O5t3pd2ShI2ugEZQSZ2Kna+Jq76V5hpZ8+2Fq8T KA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38ud1scfst-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 07:09:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15171B59151542;
        Tue, 1 Jun 2021 07:09:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 38ude83hnt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 07:09:05 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 15174Vr5177364;
        Tue, 1 Jun 2021 07:09:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 38ude83hkw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 01 Jun 2021 07:09:04 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 15178ssR009874;
        Tue, 1 Jun 2021 07:08:58 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Jun 2021 00:08:53 -0700
Date:   Tue, 1 Jun 2021 10:08:44 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: Re: [PATCH 5.4 135/177] net: netcp: Fix an error message
Message-ID: <20210601070844.GC24442@kadam>
References: <20210531130647.887605866@linuxfoundation.org>
 <20210531130652.606363904@linuxfoundation.org>
 <60ba11bd-acc0-d48d-ad80-6987847e6e79@wanadoo.fr>
 <YLVYRMy9DTEsco+d@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLVYRMy9DTEsco+d@sashalap>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: lgBS8shzHlihI4KTKiIb9WFmMAMqrL_5
X-Proofpoint-GUID: lgBS8shzHlihI4KTKiIb9WFmMAMqrL_5
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10001 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106010049
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 05:42:28PM -0400, Sasha Levin wrote:
> > Hi,
> > 
> > Apparently %pe is only supported up to (including) 5.5. It is not part
> > of 5.4.123.
> > 

It seems like it would be easier to just back port the %pe commit to
v5.4?  It seems to apply and build basically fine?  I didn't try test
it.  It's commit 57f5677e535b ("printf: add support for printing
symbolic error names").

Rasmus, we were always wondering when you were going to make it work
for integer error codes.  ;)

regards,
dan carpenter
