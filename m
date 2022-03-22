Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 027E04E47B0
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 21:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiCVUoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 16:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234276AbiCVUod (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 16:44:33 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3100DE8D
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 13:43:03 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id m3so19822387lfj.11
        for <stable@vger.kernel.org>; Tue, 22 Mar 2022 13:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XEs5CaxwBOrmU2Bt/TJ7tHMsqFDUqIub0OwTMRXkbqs=;
        b=EItqd0rXUiNN+0vBWaPz9O9B7Or80LpgXd12JmBTqbcYbH/Sjvl787nxSlqUD/QR8Y
         C5/9C3qQMRMXDPaVo7g+gQNqhSKeibmOyjr5EsahGa7fcUUMbK0iL19iswKP6O2dWdJH
         dwp2XCAMmsb0MRkAGhfA/Y6bIvyLL0DpSFldl0LE1t7HEFfTxxCVNH4WDYO7a3Yjy4+x
         f5RF2t/YH0YZFkU2XMhfkvwYYfJtDLRaUi4RUwH1/VklY0jk68hmis+tT305KssmtuWw
         wjs2v8RGD6zmsGeLRzNDHfyWg90oBYZkp9HDUk4M/FJ9C0S3f6m4Jz9mKkRJt8e9lffe
         jhcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XEs5CaxwBOrmU2Bt/TJ7tHMsqFDUqIub0OwTMRXkbqs=;
        b=FRHXUK1O9obisTWCkfKw20DsWmdcgcKZMhZjlDTBUtx7H5ZQV7JOCIzJblp/uDyqRk
         MqOc/4xdiuWcQsAUqrDXFXKDIAJDKgcH8C8oseIk9USsXi7p1mSvFpDJN7quqQbzJNxn
         k+1LfVG61WrJLofFFpiqXehK+NxD4Ev5+w93ugP21X18YqimDmR/OTvyqsxCtcHDw6vk
         nT70ppQDHRhi3yKYf17w+pd09Imvlyggj390CkpUGhUCZvrZng0tRD6lGpH4snzqLyyP
         Chhrx5Yap8KY1Fxrrd1hwgD0Ue28RijlhpfIFlKp6QPTPUUA2LoJc5SKyJ2alp1wafNP
         DUdg==
X-Gm-Message-State: AOAM530nI4BjIw1iRrPAgTz9t/57BxfYpnAok7uyU7pzSHAUOfz0r7q2
        Q2CZoA8+wQvK1H3cAIFhRcXNYgB6CuXZ4Z5xNr0EPbYixTY=
X-Google-Smtp-Source: ABdhPJzn+VNNI/4SnSkIJ7qKRmMXxPIhjCG6aTby0+qsak419IXd3nGP3/a+kYBQXauKmkMuEL2UZZJYRpywx9RaFog=
X-Received: by 2002:a05:6512:1114:b0:448:388c:b79f with SMTP id
 l20-20020a056512111400b00448388cb79fmr19500738lfg.250.1647981781601; Tue, 22
 Mar 2022 13:43:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAMVonLjSP4cxtfahDORXG-b6K=ps+wN652hcrxgo70YU+eP5iA@mail.gmail.com>
 <YjmCh1SPUOJjM7Rf@kroah.com> <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
In-Reply-To: <CAMVonLh6_puoNcOEU3XRHRf1Pa1iCjcQ1H8GGvbmTccHjys6vQ@mail.gmail.com>
From:   Vaibhav Rustagi <vaibhavrustagi@google.com>
Date:   Tue, 22 Mar 2022 13:42:50 -0700
Message-ID: <CAMVonLjPRNMGHW10JOTS2LuEtQ3ZeoYzRTibPyeUg05Rq3pg8A@mail.gmail.com>
Subject: Re: Cherry-pick request to fix CVE-2022-0886 in v5.10 and v5.4
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>, steffen.klassert@secunet.com
Content-Type: multipart/mixed; boundary="000000000000b0f4f505dad4a8e2"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000b0f4f505dad4a8e2
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 22, 2022 at 9:53 AM Vaibhav Rustagi
<vaibhavrustagi@google.com> wrote:
>
> On Tue, Mar 22, 2022 at 2:04 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Mar 21, 2022 at 06:49:02PM -0700, Vaibhav Rustagi wrote:
> > > Hi Greg,
> > >
> > > To fix CVE-2022-0886 in v5.10 and v5.4, we need to cherry-pick the
> > > commit "esp: Fix possible buffer overflow in ESP transformation"
> > > (ebe48d368e97d007bfeb76fcb065d6cfc4c96645). The commit didn't apply
> > > cleanly in v5.10 and v5.4 and therefore, patches for both the kernel
> > > versions are attached.
> > >
> > > In order to backport the original commit, following changes are done:
> > >
> > >  - v5.10:
> > >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > > "net/core/sock.c" to "include/net/sock.c"
> >
> > Did you see that this is already in the 5.10 queue and out for review
> > right now?  Can you verify that the backport there matches yours?
> >
>
> I was not aware that I could check that. Thanks for the hint.
>
> The change is not exactly identical. In addition to the change
> mentioned in https://www.spinics.net/lists/stable/msg542796.html, I
> have also removed following from "net/core/sock.c":
>
> -#define SKB_FRAG_PAGE_ORDER get_order(32768)
>
> This is done because "net/core/sock.c" includes "include/net/sock.h"
> which defined the MACRO.
>
> > >  - v5.4:
> > >     - "SKB_FRAG_PAGE_ORDER" declaration is moved from
> > > "net/core/sock.c" to "include/net/sock.c"
> > >     - Ignore changes introduced due to `xfrm: add support for UDPv6
> > > encapsulation of ESP` in esp6_output_head()
> >
> > Thanks for this one, I'll queue it up after this next round of releases.
> > What about 4.14 and 4.19?  Will this backport work there?  If not, can
> > you provide a working one?
> >
>
> I haven't tested the change in v4.14 and v4.19. I will check out those
> trees and check whether the current patch will work or not.
>

The changes for v4.14 and v4.19 are the same as what is sent for v5.4.
However, the v5.4 patch didn't apply cleanly and I have attached
patches for v4.14 (tested build on v4.14.272) and v4.19 (tested build
on v4.19.235).

> > thanks,
> >
> > greg k-h
>
> Regards,
> Vaibhav

--000000000000b0f4f505dad4a8e2
Content-Type: application/octet-stream; 
	name="4-14-esp-Fix-possible-buffer-overflow-in-ESP-transformati.patch"
Content-Disposition: attachment; 
	filename="4-14-esp-Fix-possible-buffer-overflow-in-ESP-transformati.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l12ls02a1>
X-Attachment-Id: f_l12ls02a1

RnJvbSA1MTQ2MjJhMjZlMWIxNGIzOTZiMDc0ZmFmMGM3YjhlZDA2MGM4ODJiIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmZmVuIEtsYXNzZXJ0IDxzdGVmZmVuLmtsYXNzZXJ0QHNl
Y3VuZXQuY29tPgpEYXRlOiBNb24sIDcgTWFyIDIwMjIgMTM6MTE6MzkgKzAxMDAKU3ViamVjdDog
W1BBVENIXSBlc3A6IEZpeCBwb3NzaWJsZSBidWZmZXIgb3ZlcmZsb3cgaW4gRVNQIHRyYW5zZm9y
bWF0aW9uCgpbIFVwc3RyZWFtIGNvbW1pdCBlYmU0OGQzNjhlOTdkMDA3YmZlYjc2ZmNiMDY1ZDZj
ZmM0Yzk2NjQ1IF0KClRoZSBtYXhpbXVtIG1lc3NhZ2Ugc2l6ZSB0aGF0IGNhbiBiZSBzZW5kIGlz
IGJpZ2dlciB0aGFuCnRoZSAgbWF4aW11bSBzaXRlIHRoYXQgc2tiX3BhZ2VfZnJhZ19yZWZpbGwg
Y2FuIGFsbG9jYXRlLgpTbyBpdCBpcyBwb3NzaWJsZSB0byB3cml0ZSBiZXlvbmQgdGhlIGFsbG9j
YXRlZCBidWZmZXIuCgpGaXggdGhpcyBieSBkb2luZyBhIGZhbGxiYWNrIHRvIENPVyBpbiB0aGF0
IGNhc2UuCgp2MjoKCkF2b2lkIGdldCBnZXRfb3JkZXIoKSBjb3N0cyBhcyBzdWdnZXN0ZWQgYnkg
TGludXMgVG9ydmFsZHMuCgpGaXhlczogY2FjMjY2MWM1M2YzICgiZXNwNDogQXZvaWQgc2tiX2Nv
d19kYXRhIHdoZW5ldmVyIHBvc3NpYmxlIikKRml4ZXM6IDAzZTJhMzBmNmEyNyAoImVzcDY6IEF2
b2lkIHNrYl9jb3dfZGF0YSB3aGVuZXZlciBwb3NzaWJsZSIpClJlcG9ydGVkLWJ5OiB2YWxpcyA8
c2VjQHZhbGlzLmVtYWlsPgpTaWduZWQtb2ZmLWJ5OiBTdGVmZmVuIEtsYXNzZXJ0IDxzdGVmZmVu
LmtsYXNzZXJ0QHNlY3VuZXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBWYWliaGF2IFJ1c3RhZ2kgPHZh
aWJoYXZydXN0YWdpQGdvb2dsZS5jb20+Ci0tLQogaW5jbHVkZS9uZXQvZXNwLmggIHwgMiArKwog
aW5jbHVkZS9uZXQvc29jay5oIHwgMyArKysKIG5ldC9jb3JlL3NvY2suYyAgICB8IDMgLS0tCiBu
ZXQvaXB2NC9lc3A0LmMgICAgfCA1ICsrKysrCiBuZXQvaXB2Ni9lc3A2LmMgICAgfCA1ICsrKysr
CiA1IGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9uZXQvZXNwLmggYi9pbmNsdWRlL25ldC9lc3AuaAppbmRleCAxMTc2
NTJlYjZlYTMuLjQ2NWUzODg5MGVlOSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvZXNwLmgKKysr
IGIvaW5jbHVkZS9uZXQvZXNwLmgKQEAgLTQsNiArNCw4IEBACiAKICNpbmNsdWRlIDxsaW51eC9z
a2J1ZmYuaD4KIAorI2RlZmluZSBFU1BfU0tCX0ZSQUdfTUFYU0laRSAoUEFHRV9TSVpFIDw8IFNL
Ql9GUkFHX1BBR0VfT1JERVIpCisKIHN0cnVjdCBpcF9lc3BfaGRyOwogCiBzdGF0aWMgaW5saW5l
IHN0cnVjdCBpcF9lc3BfaGRyICppcF9lc3BfaGRyKGNvbnN0IHN0cnVjdCBza19idWZmICpza2Ip
CmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9zb2NrLmggYi9pbmNsdWRlL25ldC9zb2NrLmgKaW5k
ZXggMDI5ZGY1Y2RlYWYxLi5mNzI3NTMzOTFhY2MgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L3Nv
Y2suaAorKysgYi9pbmNsdWRlL25ldC9zb2NrLmgKQEAgLTI0MzgsNCArMjQzOCw3IEBAIGV4dGVy
biBpbnQgc3lzY3RsX29wdG1lbV9tYXg7CiBleHRlcm4gX191MzIgc3lzY3RsX3dtZW1fZGVmYXVs
dDsKIGV4dGVybiBfX3UzMiBzeXNjdGxfcm1lbV9kZWZhdWx0OwogCisvKiBPbiAzMmJpdCBhcmNo
ZXMsIGFuIHNrYiBmcmFnIGlzIGxpbWl0ZWQgdG8gMl4xNSAqLworI2RlZmluZSBTS0JfRlJBR19Q
QUdFX09SREVSCWdldF9vcmRlcigzMjc2OCkKKwogI2VuZGlmCS8qIF9TT0NLX0ggKi8KZGlmZiAt
LWdpdCBhL25ldC9jb3JlL3NvY2suYyBiL25ldC9jb3JlL3NvY2suYwppbmRleCA0MjcwMjQ1OTcy
MDQuLmJiZjk1MTcyMThmZiAxMDA2NDQKLS0tIGEvbmV0L2NvcmUvc29jay5jCisrKyBiL25ldC9j
b3JlL3NvY2suYwpAQCAtMjE5Myw5ICsyMTkzLDYgQEAgc3RhdGljIHZvaWQgc2tfbGVhdmVfbWVt
b3J5X3ByZXNzdXJlKHN0cnVjdCBzb2NrICpzaykKIAl9CiB9CiAKLS8qIE9uIDMyYml0IGFyY2hl
cywgYW4gc2tiIGZyYWcgaXMgbGltaXRlZCB0byAyXjE1ICovCi0jZGVmaW5lIFNLQl9GUkFHX1BB
R0VfT1JERVIJZ2V0X29yZGVyKDMyNzY4KQotCiAvKioKICAqIHNrYl9wYWdlX2ZyYWdfcmVmaWxs
IC0gY2hlY2sgdGhhdCBhIHBhZ2VfZnJhZyBjb250YWlucyBlbm91Z2ggcm9vbQogICogQHN6OiBt
aW5pbXVtIHNpemUgb2YgdGhlIGZyYWdtZW50IHdlIHdhbnQgdG8gZ2V0CmRpZmYgLS1naXQgYS9u
ZXQvaXB2NC9lc3A0LmMgYi9uZXQvaXB2NC9lc3A0LmMKaW5kZXggOWU2NjRiNmNlZjEzLi4zOGUy
YWEyYjJhMzEgMTAwNjQ0Ci0tLSBhL25ldC9pcHY0L2VzcDQuYworKysgYi9uZXQvaXB2NC9lc3A0
LmMKQEAgLTI1Nyw2ICsyNTcsNyBAQCBpbnQgZXNwX291dHB1dF9oZWFkKHN0cnVjdCB4ZnJtX3N0
YXRlICp4LCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgZXNwX2luZm8gKgogCXN0cnVjdCBw
YWdlICpwYWdlOwogCXN0cnVjdCBza19idWZmICp0cmFpbGVyOwogCWludCB0YWlsZW4gPSBlc3At
PnRhaWxlbjsKKwl1bnNpZ25lZCBpbnQgYWxsb2NzejsKIAogCS8qIHRoaXMgaXMgbm9uLU5VTEwg
b25seSB3aXRoIFVEUCBFbmNhcHN1bGF0aW9uICovCiAJaWYgKHgtPmVuY2FwKSB7CkBAIC0yNjYs
NiArMjY3LDEwIEBAIGludCBlc3Bfb3V0cHV0X2hlYWQoc3RydWN0IHhmcm1fc3RhdGUgKngsIHN0
cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBlc3BfaW5mbyAqCiAJCQlyZXR1cm4gZXJyOwogCX0K
IAorCWFsbG9jc3ogPSBBTElHTihza2ItPmRhdGFfbGVuICsgdGFpbGVuLCBMMV9DQUNIRV9CWVRF
Uyk7CisJaWYgKGFsbG9jc3ogPiBFU1BfU0tCX0ZSQUdfTUFYU0laRSkKKwkJZ290byBjb3c7CisK
IAlpZiAoIXNrYl9jbG9uZWQoc2tiKSkgewogCQlpZiAodGFpbGVuIDw9IHNrYl90YWlscm9vbShz
a2IpKSB7CiAJCQluZnJhZ3MgPSAxOwpkaWZmIC0tZ2l0IGEvbmV0L2lwdjYvZXNwNi5jIGIvbmV0
L2lwdjYvZXNwNi5jCmluZGV4IGRkMWY0ZWQzZmMyYi4uYTliYWY1NjJiYjliIDEwMDY0NAotLS0g
YS9uZXQvaXB2Ni9lc3A2LmMKKysrIGIvbmV0L2lwdjYvZXNwNi5jCkBAIC0yMjMsNiArMjIzLDEx
IEBAIGludCBlc3A2X291dHB1dF9oZWFkKHN0cnVjdCB4ZnJtX3N0YXRlICp4LCBzdHJ1Y3Qgc2tf
YnVmZiAqc2tiLCBzdHJ1Y3QgZXNwX2luZm8KIAlzdHJ1Y3QgcGFnZSAqcGFnZTsKIAlzdHJ1Y3Qg
c2tfYnVmZiAqdHJhaWxlcjsKIAlpbnQgdGFpbGVuID0gZXNwLT50YWlsZW47CisJdW5zaWduZWQg
aW50IGFsbG9jc3o7CisKKwlhbGxvY3N6ID0gQUxJR04oc2tiLT5kYXRhX2xlbiArIHRhaWxlbiwg
TDFfQ0FDSEVfQllURVMpOworCWlmIChhbGxvY3N6ID4gRVNQX1NLQl9GUkFHX01BWFNJWkUpCisJ
CWdvdG8gY293OwogCiAJaWYgKCFza2JfY2xvbmVkKHNrYikpIHsKIAkJaWYgKHRhaWxlbiA8PSBz
a2JfdGFpbHJvb20oc2tiKSkgewotLSAKMi4zNS4xLjEwMjEuZzM4MTEwMWIwNzUtZ29vZwoK
--000000000000b0f4f505dad4a8e2
Content-Type: application/octet-stream; 
	name="4-19-esp-Fix-possible-buffer-overflow-in-ESP-transformati.patch"
Content-Disposition: attachment; 
	filename="4-19-esp-Fix-possible-buffer-overflow-in-ESP-transformati.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l12ls0250>
X-Attachment-Id: f_l12ls0250

RnJvbSA4NjVkZDE3MDVkZDRjNWU1MGQyYTU4ZTVkN2RhYzI2ZGM3NTRlZDU2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBTdGVmZmVuIEtsYXNzZXJ0IDxzdGVmZmVuLmtsYXNzZXJ0QHNl
Y3VuZXQuY29tPgpEYXRlOiBNb24sIDcgTWFyIDIwMjIgMTM6MTE6MzkgKzAxMDAKU3ViamVjdDog
W1BBVENIXSBlc3A6IEZpeCBwb3NzaWJsZSBidWZmZXIgb3ZlcmZsb3cgaW4gRVNQIHRyYW5zZm9y
bWF0aW9uCgpbIFVwc3RyZWFtIGNvbW1pdCBlYmU0OGQzNjhlOTdkMDA3YmZlYjc2ZmNiMDY1ZDZj
ZmM0Yzk2NjQ1IF0KClRoZSBtYXhpbXVtIG1lc3NhZ2Ugc2l6ZSB0aGF0IGNhbiBiZSBzZW5kIGlz
IGJpZ2dlciB0aGFuCnRoZSAgbWF4aW11bSBzaXRlIHRoYXQgc2tiX3BhZ2VfZnJhZ19yZWZpbGwg
Y2FuIGFsbG9jYXRlLgpTbyBpdCBpcyBwb3NzaWJsZSB0byB3cml0ZSBiZXlvbmQgdGhlIGFsbG9j
YXRlZCBidWZmZXIuCgpGaXggdGhpcyBieSBkb2luZyBhIGZhbGxiYWNrIHRvIENPVyBpbiB0aGF0
IGNhc2UuCgp2MjoKCkF2b2lkIGdldCBnZXRfb3JkZXIoKSBjb3N0cyBhcyBzdWdnZXN0ZWQgYnkg
TGludXMgVG9ydmFsZHMuCgpGaXhlczogY2FjMjY2MWM1M2YzICgiZXNwNDogQXZvaWQgc2tiX2Nv
d19kYXRhIHdoZW5ldmVyIHBvc3NpYmxlIikKRml4ZXM6IDAzZTJhMzBmNmEyNyAoImVzcDY6IEF2
b2lkIHNrYl9jb3dfZGF0YSB3aGVuZXZlciBwb3NzaWJsZSIpClJlcG9ydGVkLWJ5OiB2YWxpcyA8
c2VjQHZhbGlzLmVtYWlsPgpTaWduZWQtb2ZmLWJ5OiBTdGVmZmVuIEtsYXNzZXJ0IDxzdGVmZmVu
LmtsYXNzZXJ0QHNlY3VuZXQuY29tPgpTaWduZWQtb2ZmLWJ5OiBWYWliaGF2IFJ1c3RhZ2kgPHZh
aWJoYXZydXN0YWdpQGdvb2dsZS5jb20+Ci0tLQogaW5jbHVkZS9uZXQvZXNwLmggIHwgMiArKwog
aW5jbHVkZS9uZXQvc29jay5oIHwgMyArKysKIG5ldC9jb3JlL3NvY2suYyAgICB8IDMgLS0tCiBu
ZXQvaXB2NC9lc3A0LmMgICAgfCA1ICsrKysrCiBuZXQvaXB2Ni9lc3A2LmMgICAgfCA1ICsrKysr
CiA1IGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvaW5jbHVkZS9uZXQvZXNwLmggYi9pbmNsdWRlL25ldC9lc3AuaAppbmRleCAxMTc2
NTJlYjZlYTMuLjQ2NWUzODg5MGVlOSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9uZXQvZXNwLmgKKysr
IGIvaW5jbHVkZS9uZXQvZXNwLmgKQEAgLTQsNiArNCw4IEBACiAKICNpbmNsdWRlIDxsaW51eC9z
a2J1ZmYuaD4KIAorI2RlZmluZSBFU1BfU0tCX0ZSQUdfTUFYU0laRSAoUEFHRV9TSVpFIDw8IFNL
Ql9GUkFHX1BBR0VfT1JERVIpCisKIHN0cnVjdCBpcF9lc3BfaGRyOwogCiBzdGF0aWMgaW5saW5l
IHN0cnVjdCBpcF9lc3BfaGRyICppcF9lc3BfaGRyKGNvbnN0IHN0cnVjdCBza19idWZmICpza2Ip
CmRpZmYgLS1naXQgYS9pbmNsdWRlL25ldC9zb2NrLmggYi9pbmNsdWRlL25ldC9zb2NrLmgKaW5k
ZXggNzU2NzcwNTBjODJlLi4yYmY4ZGNmODYzZjIgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbmV0L3Nv
Y2suaAorKysgYi9pbmNsdWRlL25ldC9zb2NrLmgKQEAgLTI1MTgsNiArMjUxOCw5IEBAIGV4dGVy
biBpbnQgc3lzY3RsX29wdG1lbV9tYXg7CiBleHRlcm4gX191MzIgc3lzY3RsX3dtZW1fZGVmYXVs
dDsKIGV4dGVybiBfX3UzMiBzeXNjdGxfcm1lbV9kZWZhdWx0OwogCisvKiBPbiAzMmJpdCBhcmNo
ZXMsIGFuIHNrYiBmcmFnIGlzIGxpbWl0ZWQgdG8gMl4xNSAqLworI2RlZmluZSBTS0JfRlJBR19Q
QUdFX09SREVSCWdldF9vcmRlcigzMjc2OCkKKwogc3RhdGljIGlubGluZSBpbnQgc2tfZ2V0X3dt
ZW0wKGNvbnN0IHN0cnVjdCBzb2NrICpzaywgY29uc3Qgc3RydWN0IHByb3RvICpwcm90bykKIHsK
IAkvKiBEb2VzIHRoaXMgcHJvdG8gaGF2ZSBwZXIgbmV0bnMgc3lzY3RsX3dtZW0gPyAqLwpkaWZm
IC0tZ2l0IGEvbmV0L2NvcmUvc29jay5jIGIvbmV0L2NvcmUvc29jay5jCmluZGV4IDQxYTc3MDI3
YTU0OS4uNzlmMDg1ZGY1MmNlIDEwMDY0NAotLS0gYS9uZXQvY29yZS9zb2NrLmMKKysrIGIvbmV0
L2NvcmUvc29jay5jCkBAIC0yMjA3LDkgKzIyMDcsNiBAQCBzdGF0aWMgdm9pZCBza19sZWF2ZV9t
ZW1vcnlfcHJlc3N1cmUoc3RydWN0IHNvY2sgKnNrKQogCX0KIH0KIAotLyogT24gMzJiaXQgYXJj
aGVzLCBhbiBza2IgZnJhZyBpcyBsaW1pdGVkIHRvIDJeMTUgKi8KLSNkZWZpbmUgU0tCX0ZSQUdf
UEFHRV9PUkRFUglnZXRfb3JkZXIoMzI3NjgpCi0KIC8qKgogICogc2tiX3BhZ2VfZnJhZ19yZWZp
bGwgLSBjaGVjayB0aGF0IGEgcGFnZV9mcmFnIGNvbnRhaW5zIGVub3VnaCByb29tCiAgKiBAc3o6
IG1pbmltdW0gc2l6ZSBvZiB0aGUgZnJhZ21lbnQgd2Ugd2FudCB0byBnZXQKZGlmZiAtLWdpdCBh
L25ldC9pcHY0L2VzcDQuYyBiL25ldC9pcHY0L2VzcDQuYwppbmRleCAwNzkyYTllMmE1NTUuLjQ1
YmI1YjYwYjk5NCAxMDA2NDQKLS0tIGEvbmV0L2lwdjQvZXNwNC5jCisrKyBiL25ldC9pcHY0L2Vz
cDQuYwpAQCAtMjc1LDYgKzI3NSw3IEBAIGludCBlc3Bfb3V0cHV0X2hlYWQoc3RydWN0IHhmcm1f
c3RhdGUgKngsIHN0cnVjdCBza19idWZmICpza2IsIHN0cnVjdCBlc3BfaW5mbyAqCiAJc3RydWN0
IHBhZ2UgKnBhZ2U7CiAJc3RydWN0IHNrX2J1ZmYgKnRyYWlsZXI7CiAJaW50IHRhaWxlbiA9IGVz
cC0+dGFpbGVuOworCXVuc2lnbmVkIGludCBhbGxvY3N6OwogCiAJLyogdGhpcyBpcyBub24tTlVM
TCBvbmx5IHdpdGggVURQIEVuY2Fwc3VsYXRpb24gKi8KIAlpZiAoeC0+ZW5jYXApIHsKQEAgLTI4
NCw2ICsyODUsMTAgQEAgaW50IGVzcF9vdXRwdXRfaGVhZChzdHJ1Y3QgeGZybV9zdGF0ZSAqeCwg
c3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0IGVzcF9pbmZvICoKIAkJCXJldHVybiBlcnI7CiAJ
fQogCisJYWxsb2NzeiA9IEFMSUdOKHNrYi0+ZGF0YV9sZW4gKyB0YWlsZW4sIEwxX0NBQ0hFX0JZ
VEVTKTsKKwlpZiAoYWxsb2NzeiA+IEVTUF9TS0JfRlJBR19NQVhTSVpFKQorCQlnb3RvIGNvdzsK
KwogCWlmICghc2tiX2Nsb25lZChza2IpKSB7CiAJCWlmICh0YWlsZW4gPD0gc2tiX3RhaWxyb29t
KHNrYikpIHsKIAkJCW5mcmFncyA9IDE7CmRpZmYgLS1naXQgYS9uZXQvaXB2Ni9lc3A2LmMgYi9u
ZXQvaXB2Ni9lc3A2LmMKaW5kZXggMjUzMTdkNWNjZjJjLi5lM2FiZmM5N2ZkZTcgMTAwNjQ0Ci0t
LSBhL25ldC9pcHY2L2VzcDYuYworKysgYi9uZXQvaXB2Ni9lc3A2LmMKQEAgLTI0MSw2ICsyNDEs
MTEgQEAgaW50IGVzcDZfb3V0cHV0X2hlYWQoc3RydWN0IHhmcm1fc3RhdGUgKngsIHN0cnVjdCBz
a19idWZmICpza2IsIHN0cnVjdCBlc3BfaW5mbwogCXN0cnVjdCBwYWdlICpwYWdlOwogCXN0cnVj
dCBza19idWZmICp0cmFpbGVyOwogCWludCB0YWlsZW4gPSBlc3AtPnRhaWxlbjsKKwl1bnNpZ25l
ZCBpbnQgYWxsb2NzejsKKworCWFsbG9jc3ogPSBBTElHTihza2ItPmRhdGFfbGVuICsgdGFpbGVu
LCBMMV9DQUNIRV9CWVRFUyk7CisJaWYgKGFsbG9jc3ogPiBFU1BfU0tCX0ZSQUdfTUFYU0laRSkK
KwkJZ290byBjb3c7CiAKIAlpZiAoIXNrYl9jbG9uZWQoc2tiKSkgewogCQlpZiAodGFpbGVuIDw9
IHNrYl90YWlscm9vbShza2IpKSB7Ci0tIAoyLjM1LjEuMTAyMS5nMzgxMTAxYjA3NS1nb29nCgo=
--000000000000b0f4f505dad4a8e2--
