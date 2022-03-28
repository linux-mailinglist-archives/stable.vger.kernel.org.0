Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21224E9068
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 10:47:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239510AbiC1Isz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 04:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239252AbiC1Isy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 04:48:54 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0E953B49;
        Mon, 28 Mar 2022 01:47:14 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S8glYX028088;
        Mon, 28 Mar 2022 08:47:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=1WMyPKuakxygvqFu/TfVrdxFzRNPw04S3K2mLjSwAqY=;
 b=FN7bpoXxpVEVExT0HMCkWVt8XoswSGn9tyQxXOkeU5gPiHYEKl9kLc5AJZlkfeWajv12
 bH94KMmt1vbRRzqmqeClXARWN3WcIHPZOmZ7J5YkXfopmsJjLOyxfMOwQY3WVakYeVZY
 hK36OSMwADqa9WUNZEkQfwxO9yR4xj44VOn9KiVQCgUfwxp6xWlvZU/syz6E1IyuMYqH
 StClJ5XePgkgf14KnFytvSJ74UQnQguQYmnsTm8xqZRc0TJFzccyWABn4YmL8vRv0AI3
 m9PCSX1+5SQ4GpjfEoNb7ycbtIi9MjWIN9u8STbLl7O/lCPRRwGPg4WU4U0rXTj6O8g/ bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2cm9wm3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:47:07 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S8ivXi004243;
        Mon, 28 Mar 2022 08:47:07 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2cm9wm39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:47:07 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S8hX8o030906;
        Mon, 28 Mar 2022 08:47:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03fra.de.ibm.com with ESMTP id 3f1tf8tyhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 08:47:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22S8l1V136700430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 08:47:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97A1AAE04D;
        Mon, 28 Mar 2022 08:47:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3BA99AE045;
        Mon, 28 Mar 2022 08:47:01 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Mar 2022 08:47:01 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, jcmvbkbc@gmail.com, elder@linaro.org,
        dsterba@suse.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] char: tty3270: fix a missing check on list iterator
References: <20220328070543.24671-1-xiam0nd.tong@gmail.com>
Date:   Mon, 28 Mar 2022 10:47:00 +0200
In-Reply-To: <20220328070543.24671-1-xiam0nd.tong@gmail.com> (Xiaomeng Tong's
        message of "Mon, 28 Mar 2022 15:05:43 +0800")
Message-ID: <yt9dczi6cvln.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: jTc4xcaF8gubDZs8biPwYCuljP5tqMgp
X-Proofpoint-GUID: O8qap2T0lA6sLN_d5XP_L1UktDNCgWnz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_02,2022-03-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=907 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280049
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Xiaomeng Tong <xiam0nd.tong@gmail.com> writes:

> --- a/drivers/s390/char/tty3270.c
> +++ b/drivers/s390/char/tty3270.c
> @@ -1111,7 +1111,7 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
>  {
>  	struct tty3270_line *line;
>  	struct tty3270_cell *cell;
> -	struct string *s, *n;
> +	struct string *s = NULL, *n, *iter;

Please keep reverse XMAS-tree layout.

>  	unsigned char highlight;
>  	unsigned char f_color;
>  	char *cp;
> @@ -1142,13 +1142,20 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
>  
>  	/* Find the line in the list. */
>  	i = tp->view.rows - 2 - line_nr;
> -	list_for_each_entry_reverse(s, &tp->lines, list)
> -		if (--i <= 0)
> +	list_for_each_entry_reverse(iter, &tp->lines, list)
> +		if (--i <= 0) {
> +			s = iter;
>  			break;
> +		}
>  	/*
>  	 * Check if the line needs to get reallocated.
>  	 */
> -	if (s->len != flen) {
> +	if (!s) {
> +		/* Reallocate string. */
> +		n = tty3270_alloc_string(tp, flen);
> +		list_add(&n->list, &tp->lines);
> +		s = n;
> +	} else if (s->len != flen) {
>  		/* Reallocate string. */
>  		n = tty3270_alloc_string(tp, flen);
>  		list_add(&n->list, &s->list);

I should have written that in my first reply, but s == NULL means
the given line number couldn't be found in the list of lines. This is
a serious error and should be warned about. So maybe something like:

if (WARN_ON(!s))
	return;

But allocating a new empty line in that case is certainly wrong.

Thanks
Sven

