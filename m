Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990034E8DAC
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 08:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiC1GDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 02:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbiC1GDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 02:03:02 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7D651594;
        Sun, 27 Mar 2022 23:01:21 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22S4ATOo016467;
        Mon, 28 Mar 2022 06:01:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : references : date : in-reply-to : message-id : mime-version :
 content-type; s=pp1; bh=V0SVYvGEETiZ+0yrHPLpx3NJIh8DK9EnE0z1apGa36M=;
 b=PwxEEvum0YlrGqf0izwFR4+KPsUkqva9A/qPpsvTOsK6xfAiIP4E0CTlmekG8jQnEdVa
 7lz09MNBNTkhKGKRRkmP1ZiQ3BzhUIi/T+/SbuTugrkggJ13ihxvcTphqCAGDTEeTMy9
 g465bYguZFBjLTHK+Uf7JLwK73Gv/I3frdDl2ywk84Qn5GC4U26cLUjAYLFjpaRYMcnM
 EnHZaIJfzXI6S97sCw6k708DUf9EvcPV5e7n+t0Hf5DYjCtXFLTnSnncVL0fppjTle2Q
 FZcpm/JHYjhUcy6uv8cygwJWtWqW+iX5v1v2egD9rL2l1HMu879SYpQbHWc8ai4OUV23 gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2cm9tp7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 06:01:08 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22S5sBQs032219;
        Mon, 28 Mar 2022 06:01:07 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f2cm9tp6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 06:01:07 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22S5vouO003352;
        Mon, 28 Mar 2022 06:01:05 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3f1t3jb7us-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Mar 2022 06:01:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22S612gq55771556
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Mar 2022 06:01:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B63AC4C046;
        Mon, 28 Mar 2022 06:01:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5331E4C044;
        Mon, 28 Mar 2022 06:01:02 +0000 (GMT)
Received: from tuxmaker.linux.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 28 Mar 2022 06:01:02 +0000 (GMT)
From:   Sven Schnelle <svens@linux.ibm.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, jcmvbkbc@gmail.com, dsterba@suse.com,
        elder@linaro.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] char: tty3270: fix a missing check on list iterator
References: <20220327064931.7775-1-xiam0nd.tong@gmail.com>
Date:   Mon, 28 Mar 2022 08:01:02 +0200
In-Reply-To: <20220327064931.7775-1-xiam0nd.tong@gmail.com> (Xiaomeng Tong's
        message of "Sun, 27 Mar 2022 14:49:31 +0800")
Message-ID: <yt9dmthad3a9.fsf@linux.ibm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KhV1cCcOGY_AtIGUiw2RpzrGl1j1HzSk
X-Proofpoint-GUID: nJHDEpIR_uGpLMnCAc1RZUrGGFNVtmNZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-28_01,2022-03-24_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 clxscore=1011 malwarescore=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280032
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

> The bug is here:
> 	if (s->len != flen) {
>
> The list iterator 's' will point to a bogus position containing
> HEAD if the list is empty or no element is found. This case must
> be checked before any use of the iterator, otherwise it may bpass
                                                      bypass? ^^^^^

> the 'if (s->len != flen) {' in theory iif s->len's value is flen.
                                        ^^^ if?
>
> To fix this bug, use a new variable 'iter' as the list iterator,
> while use the origin variable 's' as a dedicated pointer to
using?  ^^^
        
> point to the found element.
>
> Cc: stable@vger.kernel.org
> Fixes: ^1da177e4c3f4 ("Linux-2.6.12-rc2")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/s390/char/tty3270.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/s390/char/tty3270.c b/drivers/s390/char/tty3270.c
> index 5c83f71c1d0e..030e9a098d11 100644
> --- a/drivers/s390/char/tty3270.c
> +++ b/drivers/s390/char/tty3270.c
> @@ -1111,7 +1111,7 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
>  {
>  	struct tty3270_line *line;
>  	struct tty3270_cell *cell;
> -	struct string *s, *n;
> +	struct string *s = NULL, *n, *iter;
>  	unsigned char highlight;
>  	unsigned char f_color;
>  	char *cp;
> @@ -1142,13 +1142,15 @@ tty3270_convert_line(struct tty3270 *tp, int line_nr)
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
> +	if (!s || s->len != flen) {

This doesn't look right. You're checking for s == NULL here

>  		/* Reallocate string. */
>  		n = tty3270_alloc_string(tp, flen);
>  		list_add(&n->list, &s->list);

and if it is NULL, list_add() would be called here.
