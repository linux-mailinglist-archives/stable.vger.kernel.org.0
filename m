Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C916A955C
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 11:37:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbjCCKhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 05:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjCCKhr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 05:37:47 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861624DBC1;
        Fri,  3 Mar 2023 02:37:46 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id CCAFE320094C;
        Fri,  3 Mar 2023 05:37:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 03 Mar 2023 05:37:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm1; t=
        1677839862; x=1677926262; bh=/oK2gKw0WQP9P6/4o7LSk3aPOgvTeYe0l2p
        E4+Q6qcU=; b=hTNskU3uMF2rEM7dtUJ8aPxqkn1EuEEaf0PQbSAGCygA+8CRcSW
        rLMfh8M67aDs+oAnBFCK+/S8LulYlh3Yyn8DVQaIOHlSK2edFr+a13QH410VCnA0
        YrwPBqU/7eRGfo0dPJ4Yqi+dNo5Kna6/2eHMHLHX4D2gZG5UghsSMTmX0EMJRzEt
        Mz247DmMJeAhkgpFCjHTqFr9UznYDGtXrC2QnEJO5FPvZkFoFVO8MPJavL2lHM7d
        FEOr6WNdqgMGl2BPNr/xzDMjXasUbNQRazllXw7TpKRa0+lUQp9y/isG5iYGZ19O
        r/Ge+VEBmFQ3vkCzc/lDRuJJx7J+Fkl8Hng==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1677839862; x=1677926262; bh=/oK2gKw0WQP9P
        6/4o7LSk3aPOgvTeYe0l2pE4+Q6qcU=; b=WF5aLGj34/fkS4nhCoUR4X5rp5rEz
        2FWeh0jTmaKufgSz/tCLJmS6nyaZAZ41t2hk6Odn2kONDAACblD5FTiWNB0axcnh
        oaS+CBfF4sXvDH2Wp/byR5PnGkuF4Hvx7ULM+1helij/mLH0EJPNnW4dQE3scTIB
        3yKViKkCQ+PcZnuwHoJfCIerkbApWL/gIAZiV+ulAYrw5llWT3MkG7O5Zrk3bfPo
        M7zVr5Dx3bcU1rTnvryKllGkEvgq2e360OhzcH45j8NcDmrtkJblyBUO/5hPX5Es
        O+uoo3Fm06akU3XsGc0qouZmVV7yyq5MR3yY3o779jcwYblqs0+hMfLsw==
X-ME-Sender: <xms:9s0BZDxz1dPFBkQXjJrjYl-dpvYvsRdhTehHK2zLsP-3g28mfjJ1gw>
    <xme:9s0BZLQUsIIsgmJ7Dp9joirC4WlKthMJ_Vrrnx_cKrKsWFHZKtRP4UBsmzzLJ-17c
    _mAuo9BgsExThw>
X-ME-Received: <xmr:9s0BZNXg4vzg4_03VFy-ym8JuwpliYnEeGqiXTaYGa7FoSoKRKPjIOky8YyHmw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudelledguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffggfuvfevfhfhjggtsehgtderredttdejnecuhfhrohhmpefuihhmohhn
    ucfirghishgvrhcuoehsihhmohhnsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtg
    homheqnecuggftrfgrthhtvghrnhepueehgfegtedttedvvdektdelkefhueffgedtiefh
    keeffefhvdehuedvjeejheehnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdprghrtg
    hhlhhinhhugidrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehsihhmohhnsehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:9s0BZNiE2MHLtEDQYwWBUm888MpkL1DvNij8B9UE6RsdB6qvYKmHzg>
    <xmx:9s0BZFBk7hNO_I3ph-_WJGaYOh34VR1zNRzuh_h0rG0QLgz4iq8Pzg>
    <xmx:9s0BZGIyRwUYidKoYDj2XZWPrD72C8P6qNMUeN7plmZTlaGtPf-F6g>
    <xmx:9s0BZA-ItFwawRSyobA-8mHMgv6jxNNd2y0ZobQzkTVX2LxsX7ZDuw>
Feedback-ID: idc5945a3:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Mar 2023 05:37:35 -0500 (EST)
Message-ID: <7135b5c6-daed-a726-c02c-b0ed821e2121@invisiblethingslab.com>
Date:   Fri, 3 Mar 2023 11:38:16 +0100
MIME-Version: 1.0
Subject: Re: [regression] Bug 217114 - Tiger Lake SATA Controller not
 operating correctly [bisected]
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        emmi@emmixis.net, schwagsucks@gmail.com,
        "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)" 
        <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
References: <ad02467d-d623-5933-67e0-09925c185568@leemhuis.info>
 <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>
From:   Simon Gaiser <simon@invisiblethingslab.com>
In-Reply-To: <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eY0wtsDnTwQw10yONnf8MW0F"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------eY0wtsDnTwQw10yONnf8MW0F
Content-Type: multipart/mixed; boundary="------------B7xKDox4LcyyrC95EzxDJhv8";
 protected-headers="v1"
From: Simon Gaiser <simon@invisiblethingslab.com>
To: Damien Le Moal <damien.lemoal@opensource.wdc.com>,
 Linux regressions mailing list <regressions@lists.linux.dev>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, emmi@emmixis.net,
 schwagsucks@gmail.com,
 "open list:LIBATA SUBSYSTEM (Serial and Parallel ATA drivers)"
 <linux-ide@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Message-ID: <7135b5c6-daed-a726-c02c-b0ed821e2121@invisiblethingslab.com>
Subject: Re: [regression] Bug 217114 - Tiger Lake SATA Controller not
 operating correctly [bisected]
References: <ad02467d-d623-5933-67e0-09925c185568@leemhuis.info>
 <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>
In-Reply-To: <af6a355b-3ac2-a610-379a-167e87145368@opensource.wdc.com>

--------------B7xKDox4LcyyrC95EzxDJhv8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Damien Le Moal:
> On 3/3/23 16:10, Linux regression tracking (Thorsten Leemhuis) wrote:
>> Hi, this is your Linux kernel regression tracker.
>>
>> I noticed a regression report in bugzilla.kernel.org that apparently
>> affects 6.2 and later as well as 6.1.13 and later, as it was already
>> backported there.
>>
>> As many (most?) kernel developer don't keep an eye on bugzilla, I
>> decided to forward the report by mail. Quoting from
>> https://bugzilla.kernel.org/show_bug.cgi?id=3D217114 :
>>
>>>  emmi@emmixis.net 2023-03-02 11:25:00 UTC
>>>
>>> As per kernel problem found in https://bbs.archlinux.org/viewtopic.ph=
p?id=3D283906 ,
>>>
>>> Commit 104ff59af73aba524e57ae0fef70121643ff270e
>>
>> [FWIW: That's "ata: ahci: Add Tiger Lake UP{3,4} AHCI controller" from=

>> Simon Gaiser]
>=20
> I sent a revert with cc: stable.
>=20
> Simon,
>=20
> Let's work on finding a better solution for enabling LPM for that
> adapter without causing regressions. I will need your help for testing
> as I do not have this hardware.

Sure, let me know what I can do to help.

Simon

--------------B7xKDox4LcyyrC95EzxDJhv8--

--------------eY0wtsDnTwQw10yONnf8MW0F
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE3E8ezGzG3N1CTQ//kO9xfO/xly8FAmQBzhoACgkQkO9xfO/x
ly9odw/+McAW/GtDWNrqJlk1I1G1Zbsxv5yhwxT17Ma4A9+VItJj16T3ot6GhxFX
S4EaEGBl1pipfJyrUoUNdcJk+Kg0XTriTVH0fJl1I66ekFPPmrOa1bigJ1bHKBMk
EJPx94Av2CNhKTAV1HZ4nSJaO8vZ2+wJ704yDxSEP8eqsAsr/48eGvV04KL6cL6P
XhUPDstOsmB3SaG0HnXA7aSNPeTJ4SaV8Pz4Em68n92r5/+eVEZu5gzq/xQBTkdB
3J0gizkm2TR2lNdEvNOMNaHaUaOyOQuXtyDOuxlF3jmOoKgiDMGpdlu7W1gWwTT6
iBNZnP4g10eooTb/hHtsdvVSsP81pi1RdMJ60n3W6TantQ0BkaM35WPIRxFBhKj1
+6ov8fQ6LOm0cJOaHJvsOhVa24CYJXbMS0I9avi/3c9D7AWIUfiSoDXxrvql4BIq
xziQ6EKu2s6haFKZzd/7WRCECnr6+vsqvrCZmMZClyoN3f8GOUn1XkrtO0emwrA/
+DuivP0l9/40ECTIQkv4j2zYIYKaqws9vsrxGiRCdTOSB7ylMjwXC9YAX4F1OdkJ
MeR0HzL76MXAIb6R+Nv7qoicKgLdkVORNlz8gMhW2Ga1S/Pe0AClHosuOKRZIlyF
icYwRVen9SY97Ko7fSZiVTJHLmVpCEnMe9vFEYRFxPVOOHLIbag=
=G8eI
-----END PGP SIGNATURE-----

--------------eY0wtsDnTwQw10yONnf8MW0F--
