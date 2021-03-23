Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09434610E
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 15:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbhCWOJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 10:09:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58010 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232172AbhCWOIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 10:08:53 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NE5XAJ168349;
        Tue, 23 Mar 2021 14:08:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=t/xaaVqoQ/f/LgZxiyUJNJ/HPdDx97I+V6UPT7T73Zw=;
 b=KDTLGk9W5O1Wz0M8EshdZwTkQr3W6wwWgZUf4ygIuJ6QnZKpoPDIyPbH08BFEb9K74CB
 45UhNaoHWAe7us81QLdpKmJzU6J9Ln02ZuxMXupDhjhhhz49lhUUmmDvrMySqVUj3sfj
 7aAsviyDcz7uinCpOFURfqslfsyoMb+GbS/5JEBFcE5ADMhsTemxsMjCdCrFOrx269Ee
 o/DcfVYQalcUCcV3pzQIdamjK6bByUJKd4gSoJHVMhuqEHmd3HHmbItwM9WmhDzfeFqY
 6ocuqZo51WZ9c+wpA0QTF8auBrZ+W5YGvqzOcf641LqhlcxRBbZlxj5C4ahTd8p5wHLu Ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37d90mf4y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 14:08:39 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12NE69h1048265;
        Tue, 23 Mar 2021 14:08:37 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 37dttryu6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Mar 2021 14:08:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 12NE8abE026048;
        Tue, 23 Mar 2021 14:08:36 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Mar 2021 07:08:35 -0700
Date:   Tue, 23 Mar 2021 17:08:28 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Atul Gopinathan <atulgopinathan@gmail.com>
Cc:     gregkh@linuxfoundation.org, linux-staging@lists.linux.dev,
        linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] staging: rtl8192e: Change state information from
 u16 to u8
Message-ID: <20210323140828.GJ1717@kadam>
References: <20210323113413.29179-1-atulgopinathan@gmail.com>
 <20210323113413.29179-2-atulgopinathan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323113413.29179-2-atulgopinathan@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230105
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9931 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103230105
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

