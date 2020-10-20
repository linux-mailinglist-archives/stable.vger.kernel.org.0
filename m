Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D51294444
	for <lists+stable@lfdr.de>; Tue, 20 Oct 2020 23:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438656AbgJTVKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Oct 2020 17:10:00 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:56250 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438655AbgJTVKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Oct 2020 17:10:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KL0C0A127411;
        Tue, 20 Oct 2020 21:09:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ZY42jQ7uBytgNE6jHPQfJVTlzsqVTNBlsAj5UFv6F20=;
 b=XZhH+rsrVKTCYGUS2ykQyZMYevD4T//pyEpwzd03L1mF59QqxJnT4rDqwcP7gXyn4Jff
 Sn+qPz/yLuM2nFqoc3DZTqnA2brJS72rNs5WO+q7aUF0c4rC0bA6Jaiw20C5atEwDe+y
 UrXGLnGmcs3t73c6nbSwqBxX/V9kO/I2lgBcwyf+amLjIw4qPb9THd9+dKtHGMImeCu5
 JOJAhBme9vba6zgOx7KEEIOwTAv/nUNJsVBnen9Kre2Pe/lLwin7A77iVuC+xZ/zzle8
 txA5m8UnbA1mHOGljsdnQw3qETusHkM23GWvS+vgHALNO+8isaECVlt0CDDUSyrDR9J3 6g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 347s8mwbft-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 20 Oct 2020 21:09:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09KL0weB160674;
        Tue, 20 Oct 2020 21:09:57 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 348ahws1nh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Oct 2020 21:09:57 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09KL9ugh024460;
        Tue, 20 Oct 2020 21:09:57 GMT
Received: from char.us.oracle.com (/10.152.32.25)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 20 Oct 2020 14:09:56 -0700
Received: by char.us.oracle.com (Postfix, from userid 1000)
        id DB07B6A00D6; Tue, 20 Oct 2020 17:11:38 -0400 (EDT)
Date:   Tue, 20 Oct 2020 17:11:38 -0400
From:   Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RFC UEK5 6/7] debugfs: Return -EPERM when locked down
Message-ID: <20201020211138.GC21080@char.us.oracle.com>
References: <20201020210004.18977-1-konrad.wilk@oracle.com>
 <20201020210004.18977-7-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020210004.18977-7-konrad.wilk@oracle.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010200143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9780 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 phishscore=0 clxscore=1015 bulkscore=0 impostorscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010200143
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 20, 2020 at 05:00:03PM -0400, Konrad Rzeszutek Wilk wrote:
> From: Eric Snowberg <eric.snowberg@oracle.com>

..monster snip..
> Cc: stable <stable@vger.kernel.org>

..stable tree folks please ignore this. 

<sigh>

My apologies for spamming you all!

<goes to hide in the corner of shame>
