Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC0874BA07E
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 14:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbiBQM7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 07:59:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbiBQM7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 07:59:06 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5852284212;
        Thu, 17 Feb 2022 04:58:52 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id s1-20020a056830148100b005acfdcb1f4bso2826803otq.4;
        Thu, 17 Feb 2022 04:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to;
        bh=4ItLHsT9GMA4Z+/1ZE9OLKoHvk5KsaRvDPYgW0Wxndo=;
        b=XqjFRi+Lr11n0mgDE75LXWRp5Vg9/r15F1YkzYVSjVMBdurarBLIjG5MsXLn3msCgC
         jFwAhLEdyV35PtZx/14nn5G8782r0Rpf6LgbYfMgrBGEpx1iej6MNivwsGM/L8SZn1Et
         b8dJ++N4fHRaF/0WQy2akPE15dxQBDk1VkpwQTNeWIZDrGh8pnxtndC2MoFkMYuAcvcM
         u3FBibd8g07HQ5FF3ib5g0IOo78kLvB+rbE9hAdEzg5d3Hx7s1P7lJJGxwtWq6jhEC/T
         QMbVQZdiIN36t8UQ+V2B3yi1l3mANrYQKpXpDA5vFDjwCMQcV28sF8pOUUZRXGxvAIp1
         Zi8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to;
        bh=4ItLHsT9GMA4Z+/1ZE9OLKoHvk5KsaRvDPYgW0Wxndo=;
        b=HA3Ci1H+UBUAL9v0EZZRao2vr+1S7+GNoEzHc1hgNbceGPcnv88GqmfEvBvatAe4Xy
         9i1omG2Ehc1D0K+bDgFQEiyn6ySLUObYkoZul7W77h9V/LwZaZZHVkyAYBlpqJzfOM0G
         R9RgjqPbtRpxyxLTQD48e0oE8GAAUoubcKIAe6VOhJFzXcyBnm3kOv2X8YWSwAW2+O95
         eH4F0hETO3BOYa3scQzCIygYNbk1VohgZ9WKdp0JbO0c3Bon9QokYL8U/Qy0sFSVdxN/
         25MmGARcXTXnPEToo/5UE9NLHXd7upflfI6TuhiVA/8YMkWPRZSazQI0tzYoHdmXq8ve
         QK8w==
X-Gm-Message-State: AOAM530MntRXgePxNZQ+QiZKvR8uKPnYXVMl19s31Rw8lmfY5wk4/rZ9
        2xYEAbsclDn3tybk0+agVBEAJ/hDYUY=
X-Google-Smtp-Source: ABdhPJzeuWqOz2ANQBh591q1b4yfz1BSsnB/mpuwSeOcUJL0vckfIGUrpIZOzqMIJjpUI9dxvcKEig==
X-Received: by 2002:a9d:6489:0:b0:5ad:1cd:94b1 with SMTP id g9-20020a9d6489000000b005ad01cd94b1mr750530otl.321.1645102731686;
        Thu, 17 Feb 2022 04:58:51 -0800 (PST)
Received: from [192.168.91.2] ([181.97.181.211])
        by smtp.gmail.com with ESMTPSA id t21sm16241569otj.26.2022.02.17.04.58.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Feb 2022 04:58:50 -0800 (PST)
Message-ID: <3c258c11-7f4b-790e-b820-9959a128a51a@gmail.com>
Date:   Thu, 17 Feb 2022 09:58:48 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: missing patch in 5.15? {drm/i915: Workaround broken BIOS DBUF
 configuration on TGL/RKL}
Content-Language: es-AR
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <3cf60426-ce15-f51c-36c9-180431f2f7d5@gmail.com>
 <Yg03NpL7WDMtQWmK@kroah.com>
From:   Gerardo Exequiel Pozzi <vmlinuz386@gmail.com>
In-Reply-To: <Yg03NpL7WDMtQWmK@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BK9ELzur0jpqCyi5gfSnWcti"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BK9ELzur0jpqCyi5gfSnWcti
Content-Type: multipart/mixed; boundary="------------31ohOSgaBHD5ofR0YG85Z9Op";
 protected-headers="v1"
From: Gerardo Exequiel Pozzi <vmlinuz386@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <3c258c11-7f4b-790e-b820-9959a128a51a@gmail.com>
Subject: Re: missing patch in 5.15? {drm/i915: Workaround broken BIOS DBUF
 configuration on TGL/RKL}
References: <3cf60426-ce15-f51c-36c9-180431f2f7d5@gmail.com>
 <Yg03NpL7WDMtQWmK@kroah.com>
In-Reply-To: <Yg03NpL7WDMtQWmK@kroah.com>

--------------31ohOSgaBHD5ofR0YG85Z9Op
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMi8xNi8yMiAxNDo0MSwgR3JlZyBLSCB3cm90ZToNCj4gT24gV2VkLCBGZWIgMTYsIDIw
MjIgYXQgMTI6Mzc6NTVQTSAtMDMwMCwgR2VyYXJkbyBFeGVxdWllbCBQb3p6aSB3cm90ZToN
Cj4+IEhpDQo+Pg0KPj4gQ2FuIGFwcGx5IHtkcm0vaTkxNTogV29ya2Fyb3VuZCBicm9rZW4g
QklPUyBEQlVGIGNvbmZpZ3VyYXRpb24gb24gVEdML1JLTH0NCj4+IFsjMV0sIHRoYXQgaXMg
bm93IGluIDUuMTYuMTAsIGluIDUuMTUgYnJhbmNoPyBBY2NvcmRpbmcgdG8gY29tbWl0IG1l
c3NhZ2UgaXMNCj4+IHZhbGlkIGZvciB2NS4xNCsuDQo+Pg0KPj4gVGFrZSBjYXJlLg0KPj4N
Cj4+DQo+PiBbIzFdIGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJu
ZWwvZ2l0L3N0YWJsZS9zdGFibGUtcXVldWUuZ2l0L2RpZmYvcmVsZWFzZXMvNS4xNi4xMC9k
cm0taTkxNS13b3JrYXJvdW5kLWJyb2tlbi1iaW9zLWRidWYtY29uZmlndXJhdGlvbi1vbi10
Z2wtcmtsLnBhdGNoP2lkPTE1NGFkMDk4YjczYmNjYWIzYjkxY2VmMzNmMGFlYzI2NzhjZWQ3
MWENCj4gDQo+IA0KPiBBcyBwcmV2aW91c2x5IHJlcG9ydGVkLCBpdCBkb2VzIG5vdCBhcHBs
eSB0byB0aGUgNS4xNS55IGtlcm5lbCBicmFuY2gNCj4gcmlnaHQgbm93LCBhcyBpdCBicmVh
a3MgdGhlIGJ1aWxkLg0KPiANCg0KT2ggT0suIEkgZGlkIG5vdCBrbm93IHRoaXMuDQoNCj4g
SG93IGRpZCB5b3UgdGVzdCB0aGlzIG9uIDUuMTUgdG8gdmVyaWZ5IHRoYXQgaXQgc29sdmVz
IHRoZSBwcm9ibGVtIGZvcg0KPiB5b3U/ICBEbyB5b3UgaGF2ZSBhIHdvcmtpbmcgcGF0Y2g/
ICBJZiBzbywgcGxlYXNlIGZvcndhcmQgaXQgdG8gdXMgc28NCj4gdGhhdCB3ZSBjYW4gYXBw
bHkgaXQuDQo+IA0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0KDQpOby4gT25seSBpbiA1
LjE2LiBTb3JyeSBmb3IgdGhlIG5vaXNlLg0KDQpUaGFua3MgZm9yIHlvdXIgdGltZSENCg==


--------------31ohOSgaBHD5ofR0YG85Z9Op--

--------------BK9ELzur0jpqCyi5gfSnWcti
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEDzNNhpiIFXj2XSrlXtUUpFvVyTgFAmIORogFAwAAAAAACgkQXtUUpFvVyThg
5wgAlTxaWATpCj5zZtV3wIl89sQPbU2zAByssRYJYSLhV1Qxk9w3hUUoo1vvmq9tlkG3gBx4nIx8
tUCVQ7v+GcOBK3I0ACf3XEckzis9499Fjpwuo/+3z159BM7nXpuoC2XjfKWikngfjfXOJTHA2i0+
ZFD2MYcsAOmtr0ot0iHWeO/6H2PhxRFIT03eGpC4yTbm5oHRTQXf8VE2nCpV8UnXDgqmDPuWoSNx
jK4VbYgw6zLCdPTLwdrQF+rXo7Esd5esnHrZTXk3WyUae3yfCxLe1fZsduyOqPz0cqJghL2TIMy/
tN3LB7tAXJ9VC+uIwBkcUEWBUVREN4T5nAjl+BBM9Q==
=nGYh
-----END PGP SIGNATURE-----

--------------BK9ELzur0jpqCyi5gfSnWcti--
