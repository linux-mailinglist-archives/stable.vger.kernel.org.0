Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA90019D7DB
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 15:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390944AbgDCNmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 09:42:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:44972 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390940AbgDCNmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 09:42:01 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 033DaDmj080839
        for <stable@vger.kernel.org>; Fri, 3 Apr 2020 09:41:59 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 305emg07r8-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 09:41:59 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <stable@vger.kernel.org> from <frankja@linux.ibm.com>;
        Fri, 3 Apr 2020 14:41:55 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 3 Apr 2020 14:41:51 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 033Dfqfp45875236
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Apr 2020 13:41:52 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E88C3AE056;
        Fri,  3 Apr 2020 13:41:51 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 70E57AE045;
        Fri,  3 Apr 2020 13:41:51 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.156.196])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  3 Apr 2020 13:41:51 +0000 (GMT)
Subject: Re: [PATCH v1 1/5] KVM: s390: vsie: Fix region 1 ASCE sanity shadow
 address checks
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        stable@vger.kernel.org
References: <20200402184819.34215-1-david@redhat.com>
 <20200402184819.34215-2-david@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; prefer-encrypt=mutual; keydata=
 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
Date:   Fri, 3 Apr 2020 15:41:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200402184819.34215-2-david@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="VuYuhIihgc8kXyA392z7lxVZk0JYHRnZj"
X-TM-AS-GCONF: 00
x-cbid: 20040313-0028-0000-0000-000003F1522F
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20040313-0029-0000-0000-000024B6E00A
Message-Id: <58888143-f27c-58e6-715e-41ff89ab6160@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_10:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 phishscore=0 malwarescore=0 bulkscore=0 mlxscore=0 impostorscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004030115
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VuYuhIihgc8kXyA392z7lxVZk0JYHRnZj
Content-Type: multipart/mixed; boundary="Vk5zZruvRNvPPgLPZS6eZqzObLnkFIpxv"

--Vk5zZruvRNvPPgLPZS6eZqzObLnkFIpxv
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 4/2/20 8:48 PM, David Hildenbrand wrote:
> In case we have a region 1 ASCE, our shadow/g3 address can have any val=
ue.
> Unfortunately, (-1UL << 64) is undefined and triggers sometimes,
> rejecting valid shadow addresses when trying to walk our shadow table
> hierarchy.
>=20
> The result is that the prefix cannot get mapped and will loop basically=

> forever trying to map it (-EAGAIN loop).
>=20
> After all, the broken check is only a sanity check, our table shadowing=

> code in kvm_s390_shadow_tables() already checks these conditions, injec=
ting
> proper translation exceptions. Turn it into a WARN_ON_ONCE().
>=20
> Fixes: 4be130a08420 ("s390/mm: add shadow gmap support")
> Cc: <stable@vger.kernel.org> # v4.8+
> Reported-by: Janosch Frank <frankja@linux.ibm.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

With the WARN_ON_ONCE fix applied I don't run into stalls or warnings
anymore, so:
Tested-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  arch/s390/mm/gmap.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
> index 2fbece47ef6f..f3dbc5bdde50 100644
> --- a/arch/s390/mm/gmap.c
> +++ b/arch/s390/mm/gmap.c
> @@ -787,14 +787,18 @@ static void gmap_call_notifier(struct gmap *gmap,=
 unsigned long start,
>  static inline unsigned long *gmap_table_walk(struct gmap *gmap,
>  					     unsigned long gaddr, int level)
>  {
> +	const int asce_type =3D gmap->asce & _ASCE_TYPE_MASK;
>  	unsigned long *table;
> =20
>  	if ((gmap->asce & _ASCE_TYPE_MASK) + 4 < (level * 4))
>  		return NULL;
>  	if (gmap_is_shadow(gmap) && gmap->removed)
>  		return NULL;
> -	if (gaddr & (-1UL << (31 + ((gmap->asce & _ASCE_TYPE_MASK) >> 2)*11))=
)
> +
> +	if (WARN_ON_ONCE(asce_type !=3D _ASCE_TYPE_REGION1) &&
> +			 gaddr & (-1UL << (31 + (asce_type >> 2) * 11)))
>  		return NULL;
> +
>  	table =3D gmap->table;
>  	switch (gmap->asce & _ASCE_TYPE_MASK) {
>  	case _ASCE_TYPE_REGION1:
>=20



--Vk5zZruvRNvPPgLPZS6eZqzObLnkFIpxv--

--VuYuhIihgc8kXyA392z7lxVZk0JYHRnZj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEwGNS88vfc9+v45Yq41TmuOI4ufgFAl6HPR8ACgkQ41TmuOI4
ufgb+RAAsxZfc7kuWec9oOuipxBnN6zTyl3YsseJhgREuvN4gfSxNKUBszxkzDe+
AkHIrRmYTssGVaixZUec+N/x/rxOh7jIdWwTpHnQGWZNZoCHKTcFtbWGqgBQbnRY
QSUhg8i+Xw+OYtvnt+54Qo2AUThNlUxF8xUVfz//Rj3Vc55DZ/T/4StxLg8aAVg3
10YXv9/uuH2wBhQ2xZUwR6OTCcArA7ewTJx+ntjjawxY0BovxpWPdSc3AkErgXed
lYB22XVCpe4SsbTLLvJLb0Tvr9lhuuPQZ6qU5iN+4Huh3ioZsMYEsC7Td/U+yCUG
FGVKKdToeglKVV7A5vA8iHBzQRQ7Tx10jeSR8hBWSQcYNNG3MWEFy5YxAvwAAOTZ
6SdXqz7lAcYhok44oexhpGV3Ccdq/orALKfeAZlqY1NLNyDqg+/9vVzSufF9ghfo
PbRtHyjgw2hJUXGPLvP/cz22pIZ4wM2g7/0SP2QskUBqy4EZALeVXHeXEW0CEgK0
V6rVojM/leoYaRqoxCD7VIv73xda3Zp6PMVAj3UNUfj8wQXh24VYEDnEe7ePJ6HX
NW6nLxJnGYCRbAqpHP68VIYIy/BbS3YcgewMhcCH4Kpt19z1W5bAFFDGjXovBP1E
m5AOfXT4s/E0nh6wtpGud43sjagTxQIoiUL77KS0V7+LkaqnLT4=
=wb7M
-----END PGP SIGNATURE-----

--VuYuhIihgc8kXyA392z7lxVZk0JYHRnZj--

