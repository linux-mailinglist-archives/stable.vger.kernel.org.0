Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D60349A4A5
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388350AbiAYAJS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:18 -0500
Received: from mout.gmx.net ([212.227.15.19]:46419 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2367774AbiAXX4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 18:56:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1643068589;
        bh=NmbQOTuyirKT5v/51AXWjexT5k8SiMW52h0CGvFQpkY=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=QjJouGxwkReiOhQCKCkjFnntMmQG1QaxS7lFVHdfqR/g2wTRpj9b4KUEOmyNkuznb
         EyvmIvLP4j9GrEdKC14bSkd+MLtKS4CQp3Gfft9kUWuuINInlIaRRWKXXMF6H7oj9h
         BFm76T3WhdEgw3Rk3IGI1+JCBfSiMfGS51darGVc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.100.20] ([46.142.35.142]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N7i8O-1mGYd52wL4-014kui; Tue, 25
 Jan 2022 00:56:29 +0100
Message-ID: <3f11ae4c-82c2-a2b9-1795-5d7824b15b5a@gmx.de>
Date:   Tue, 25 Jan 2022 00:56:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 5.16 0000/1039] 5.16.3-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:EJQTTqdFj0fNUKDkU/qAAJIs7WM01fiQLmSPrdv/4jO+VaUGxr+
 XKm8Q9jp7TIpk4xP8WqAT6fiQlobdLO1vp1iNkSh89oLggRc5dNgvMzwYgnqC/XmA3gQUzD
 NGLB3cXpaj0WZDirAccZhzR2AlRBPpFIon+ZhajVMHOyXxcNAusBlvkFh43l2EX/lWTLz2W
 50Qgwqlg3J1e3mpn7TJ3g==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MBI8Pw3aryo=:i4nO4bph94kQbvjjNbu/zI
 EF/3fddXA2KFPBVD7coS+yqc851ohVj1R6u8okqcvSqo0qlCZS89tYPgyshUxf2wO0tQEbKVl
 HfButs5eFGXmEfGny+1wXbFjADn9D2STJXO56HRoyi2GXtyKuaL9999qCsssjqmzAn0+Bej6c
 QFlsyOR5A+S3qFacirsA6EwQcVsLbH27Ychk+mRTModGTLsmHB3GFqby2+6lM0bWkQ/gmkQtd
 FQeWtULk9pl4SEmRgQFqF307CnHmjKJuF4a/bFtuUOn9jmzMUgn01Sok/K+aqooOL3CE3xf/b
 4NdmqEwjt5xUpCzoTsAg1khfUa5eL2wAmsAHd0iTprLZt427z6AnFzgjUjucDTGnrQ6FtMno8
 GmVXy5Jpe37q6WTp0XEjIeJv3Uz3njqAFvZ5TfzHmk8EJHT34px0PbAqy6lbvWL0JnTBHVFMk
 fAtZ4W56n7zF/Qc+Z8uMD/SjJg6lTxD/QHek4xRB1ZTH1Udcm1e6a1fPqiKWjfg1CA3cEQ8l0
 KQcCwHxg0cqbGoYa/cwG6Hw2PplPCUYompuBcDTlk4SnoVQ/jnis8akiXO1jRmWD42OVINVzw
 dQJvqFc6NL9qX/56RIYQfyDsXTyroIHONifhhjPAG7IHtsZcELXDiT4SQ7btL3Etl2D7Zw/da
 0TvIl63OcJrqnzpiBVzsj2+hc5p65zgYb/g9h6jPEyo23Api9Z6LPogM4FeBBeTlCEIzwcv+o
 H9blO64OyS1IF6GV0ckFYAWckwpg13fLZ/O+ddzHcYaN6rRIio5oXdQf9qwJOCnYfZEQjIb3q
 IlZfRFyyBLlpWABys+ADbvfzTojV3rnq6LWlh88fBKXhnYIzxXaT5OIy6MoXeRVPu7TdQ+8qG
 MBt1Nq0nAKVUg/yu6ZI2XQiHMuyc+t9cxDlExpG4QiUJQs7kCV/+JS6XxyM26+qUtFeIjusx0
 rkIv2ZvtY8VHyQVrhph+D7dFPNEUc6WMi1oxggsXGEvL5kFBx10nzd8mZQt3tNR/RQG4nv3rn
 d4lAjYnAfffiQzB6OmOMsY2/5ppNtJkzcZ9FljNol29RDN6aNyWOIxLzUOf89Ur0edkfkGmQZ
 QaqV9S89HWwsnM=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

hallo Greg

5.16.3-rc1

compiles, boots and runs on my x86_64
(Intel i5-11400, Fedora 35)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

=2D-
regards
Ronald

