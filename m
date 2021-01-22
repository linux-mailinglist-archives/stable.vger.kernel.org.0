Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96DBE300420
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 14:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbhAVN0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 08:26:38 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10554 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727022AbhAVN0d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 08:26:33 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10MD14PP171755;
        Fri, 22 Jan 2021 08:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=lzPIBuIu1W59dAnPbkUv/dH7aFXRRhbuO40wKKDvU0o=;
 b=gdigqzzz12xDSmzs4EMujErn+66O//HIza/dRYb0VkSsU8wnvAUnO/wASEh0OstI8njf
 ROzQMDwc9NrgvaODj4WmDnwcCp89UA/UpOu2btzD8DU0nGc73I45rzk0d9pCh6oY9co7
 yN2v6UD1LE5mKko2rs4InHAA0Ob0f5139ej+w0fUODCr4DT94n6GwJ/kTA3Ed4dEIPL/
 om0f7J487McdExvFzG+/Q2aTyGwjW9gJ7O+0YrtzEgMxgxZbvcV9l1qzjFFApc55mdLG
 IEbP6BgQNENw4cG8OLQ4waK1xltHbtK+kgL+YFM0oe3ZOyh2RmdwrwmReRt7Uwm+WcWb dQ== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367x26k3u0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 08:25:39 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10MDI80F023070;
        Fri, 22 Jan 2021 13:25:38 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 367k0kv61k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Jan 2021 13:25:38 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10MDPbde18743756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Jan 2021 13:25:37 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 87B9EBE053;
        Fri, 22 Jan 2021 13:25:37 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9A4BCBE04F;
        Fri, 22 Jan 2021 13:25:36 +0000 (GMT)
Received: from localhost (unknown [9.163.87.14])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Fri, 22 Jan 2021 13:25:36 +0000 (GMT)
From:   Fabiano Rosas <farosas@linux.ibm.com>
To:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        linuxppc-dev@lists.ozlabs.org
Cc:     =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/prom: Fix "ibm,arch-vec-5-platform-support" scan
In-Reply-To: <20210122075029.797013-1-clg@kaod.org>
References: <20210122075029.797013-1-clg@kaod.org>
Date:   Fri, 22 Jan 2021 10:25:34 -0300
Message-ID: <8735ytaysx.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-22_09:2021-01-21,2021-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 clxscore=1011 mlxlogscore=999 spamscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101220070
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

C=C3=A9dric Le Goater <clg@kaod.org> writes:

> The "ibm,arch-vec-5-platform-support" property is a list of pairs of
> bytes representing the options and values supported by the platform
> firmware. At boot time, Linux scans this list and activates the
> available features it recognizes : Radix and XIVE.
>
> A recent change modified the number of entries to loop on and 8 bytes,
> 4 pairs of { options, values } entries are always scanned. This is
> fine on KVM but not on PowerVM which can advertises less. As a
> consequence on this platform, Linux reads extra entries pointing to
> random data, interprets these as available features and tries to
> activate them, leading to a firmware crash in
> ibm,client-architecture-support.
>
> Fix that by using the property length of "ibm,arch-vec-5-platform-support=
".
>
> Cc: stable@vger.kernel.org # v4.20+
> Fixes: ab91239942a9 ("powerpc/prom: Remove VLA in prom_check_platform_sup=
port()")
> Signed-off-by: C=C3=A9dric Le Goater <clg@kaod.org>

Reviewed-by: Fabiano Rosas <farosas@linux.ibm.com>

> ---
>  arch/powerpc/kernel/prom_init.c | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/arch/powerpc/kernel/prom_init.c b/arch/powerpc/kernel/prom_i=
nit.c
> index e9d4eb6144e1..ccf77b985c8f 100644
> --- a/arch/powerpc/kernel/prom_init.c
> +++ b/arch/powerpc/kernel/prom_init.c
> @@ -1331,14 +1331,10 @@ static void __init prom_check_platform_support(vo=
id)
>  		if (prop_len > sizeof(vec))
>  			prom_printf("WARNING: ibm,arch-vec-5-platform-support longer than exp=
ected (len: %d)\n",
>  				    prop_len);
> -		prom_getprop(prom.chosen, "ibm,arch-vec-5-platform-support",
> -			     &vec, sizeof(vec));
> -		for (i =3D 0; i < sizeof(vec); i +=3D 2) {
> -			prom_debug("%d: index =3D 0x%x val =3D 0x%x\n", i / 2
> -								  , vec[i]
> -								  , vec[i + 1]);
> -			prom_parse_platform_support(vec[i], vec[i + 1],
> -						    &supported);
> +		prom_getprop(prom.chosen, "ibm,arch-vec-5-platform-support", &vec, siz=
eof(vec));
> +		for (i =3D 0; i < prop_len; i +=3D 2) {
> +			prom_debug("%d: index =3D 0x%x val =3D 0x%x\n", i / 2, vec[i], vec[i =
+ 1]);
> +			prom_parse_platform_support(vec[i], vec[i + 1], &supported);
>  		}
>  	}
