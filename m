Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB08A4B8C95
	for <lists+stable@lfdr.de>; Wed, 16 Feb 2022 16:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbiBPPiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Feb 2022 10:38:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiBPPiL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Feb 2022 10:38:11 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8536528DDF0;
        Wed, 16 Feb 2022 07:37:59 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q8so2794114oiw.7;
        Wed, 16 Feb 2022 07:37:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to
         :content-language:cc;
        bh=408O3/jylKCQyc+x6uSu5n2OqIwWg2/+PNKEi3O+oqE=;
        b=dLYzGNEOd3pa52GHFWUQDX5qHsmxOgslLZ9Db74+oabzJNO9UlH84LlN/fwCOxtfx8
         1TyMBExx+18S6xnqRv5ZnCL1sMkSWVmG0VEqh8zaIDYrwRrwz1oEHsTyL7GvFqdrBDmI
         nnSaBtH/geMh/3oBC1lHCtZSHdZdY8E+X9xmLGFSa9a0HdFK0WvA5pxLqmlskabn26Ra
         /Y6YrDnlVEV3VJD703sq+z/oS37qLV0pNpIcwDw6Xjart+7UEltJe+UEyEFGO969Dudw
         eKiDATmKWy76dGJRC2h09E+U1OU7h4oiICdsl3XkvyrVnu3yuqgHLRJolbK/KJ0T77n8
         J0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:content-language:cc;
        bh=408O3/jylKCQyc+x6uSu5n2OqIwWg2/+PNKEi3O+oqE=;
        b=G2s+HjIY7GNcABuW+/mTvYzRtfn9xkCFJDtOk8SUo2nNGwu67oP/QeOAA4AlGnGb5H
         SiDJ7/yIjNksT/LtTLSvBg9lr7v0821UAiw56AANHaMrWShyAceiKc6WlI478yy9SwJe
         UuPsOLqSsyrEOj4j+Od/X3pj7VdeetZ2WQdGZXqITF3/g0WoCFqPDnzw3fKHtX+ZF607
         W+/fdEayV/W1YfW46/QfHvhyBR4DisKSQdxLrUawvZzLOFsObqfNmeRMvbMzVHZj6+nb
         jXkQ6Mga3tzE54flEe3Fr8B0BHpoS29W3NnSyxVTmeCEKSwvW6TBo8cEblnkIDGxVura
         c57w==
X-Gm-Message-State: AOAM533rQ0VhWUlVHOInCQ4+J9QYSMeYuHOFA3kEP/ZShdgMc4eGsZzk
        fiXbOLsJLdiLrT6GFclp5edEzrJ4UIs=
X-Google-Smtp-Source: ABdhPJz9mXRH3tcldpuP+AqXxP+ZgObYTZqExdXP9XSHNBtarPvK+6oPZxgcdM19n4J5vKCo6T9x9Q==
X-Received: by 2002:aca:4005:0:b0:2d2:bfe6:7814 with SMTP id n5-20020aca4005000000b002d2bfe67814mr976637oia.140.1645025878775;
        Wed, 16 Feb 2022 07:37:58 -0800 (PST)
Received: from [192.168.91.2] ([181.97.181.211])
        by smtp.gmail.com with ESMTPSA id u32sm12076618oiw.28.2022.02.16.07.37.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 07:37:58 -0800 (PST)
Message-ID: <3cf60426-ce15-f51c-36c9-180431f2f7d5@gmail.com>
Date:   Wed, 16 Feb 2022 12:37:55 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
From:   Gerardo Exequiel Pozzi <vmlinuz386@gmail.com>
Subject: missing patch in 5.15? {drm/i915: Workaround broken BIOS DBUF
 configuration on TGL/RKL}
To:     stable@vger.kernel.org
Content-Language: es-AR
Cc:     linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------49WZW89waJcn0WypTJX5uvx1"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------49WZW89waJcn0WypTJX5uvx1
Content-Type: multipart/mixed; boundary="------------lYaXblocH9HrGpgVeC6pUjk4";
 protected-headers="v1"
From: Gerardo Exequiel Pozzi <vmlinuz386@gmail.com>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Message-ID: <3cf60426-ce15-f51c-36c9-180431f2f7d5@gmail.com>
Subject: missing patch in 5.15? {drm/i915: Workaround broken BIOS DBUF
 configuration on TGL/RKL}

--------------lYaXblocH9HrGpgVeC6pUjk4
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQ2FuIGFwcGx5IHtkcm0vaTkxNTogV29ya2Fyb3VuZCBicm9rZW4gQklPUyBEQlVG
IGNvbmZpZ3VyYXRpb24gb24gDQpUR0wvUktMfSBbIzFdLCB0aGF0IGlzIG5vdyBpbiA1LjE2
LjEwLCBpbiA1LjE1IGJyYW5jaD8gQWNjb3JkaW5nIHRvIA0KY29tbWl0IG1lc3NhZ2UgaXMg
dmFsaWQgZm9yIHY1LjE0Ky4NCg0KVGFrZSBjYXJlLg0KDQoNClsjMV0gDQpodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9zdGFibGUvc3RhYmxlLXF1
ZXVlLmdpdC9kaWZmL3JlbGVhc2VzLzUuMTYuMTAvZHJtLWk5MTUtd29ya2Fyb3VuZC1icm9r
ZW4tYmlvcy1kYnVmLWNvbmZpZ3VyYXRpb24tb24tdGdsLXJrbC5wYXRjaD9pZD0xNTRhZDA5
OGI3M2JjY2FiM2I5MWNlZjMzZjBhZWMyNjc4Y2VkNzFhDQo=

--------------lYaXblocH9HrGpgVeC6pUjk4--

--------------49WZW89waJcn0WypTJX5uvx1
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEDzNNhpiIFXj2XSrlXtUUpFvVyTgFAmINGlMFAwAAAAAACgkQXtUUpFvVyTii
2wf/XkI1Qh4bsUBXYGFyCT0L6tWwI+uPaJvmAxX/kw/kMT/aqvyX4ZV55E0LsQooVoRbCutaMeoq
Q0EnaVg4Fu5GfzPCXCUp0GSfKgKLSIG/FAGf0l986CrEAUgTI/DGYvd8qtnZTJIFKVZJAThl1N9F
H6LJ3PUqC3FXSnAgAh7iSCK+zlj/XqxcX3o50bA+lPi3Zhl9TphJe42ujiVx1sP2i6wfXVppM8O+
Y6zB6akfb1/g7xmfILdjThQ6MOKpWcGkg9xwLPiT+Ua5HRj1k71xdBHI04cGQ2wsHd/ULO3u6USE
HjOTbwK3b+gmtLlSvQVdtrjncFiRNNLF5VsGf7l3jg==
=9yJ1
-----END PGP SIGNATURE-----

--------------49WZW89waJcn0WypTJX5uvx1--
