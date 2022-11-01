Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E33596147C2
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 11:34:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiKAKen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 06:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiKAKel (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 06:34:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C465812623;
        Tue,  1 Nov 2022 03:34:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7B721338F7;
        Tue,  1 Nov 2022 10:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1667298875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OU7DhSCU70wB4uoJKXCLiOxLVptsrsoM7HQq4Kp8dyM=;
        b=nmF9b8QhmhNllTFtzLuLVe/sd0KZKoWPZEfLN/T88fjX90NXa+nUv1y6xe2j7uOreuk7qq
        IwFR3uGvaq1R3WT1a0FZigEn/8zvw4L7QHCLUtZx7np3Dn99YPqc6iY1eQ4Qw4dKVwX0W9
        lWsObj3eGSyLmigHEXcBygVA/mU2Xd0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1667298875;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OU7DhSCU70wB4uoJKXCLiOxLVptsrsoM7HQq4Kp8dyM=;
        b=WUu4jqWhbwWXaJMIunluz80UWxnQ5wUEaXV2UwWo9s5yCRM5DyxQ6m9TaMiP3P6AOFN+fl
        h/CUQvN0rGynlHCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5657713AAF;
        Tue,  1 Nov 2022 10:34:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5eMDFDv2YGNVWAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 01 Nov 2022 10:34:35 +0000
Message-ID: <88e835b3-4075-e1a3-9201-8ab5c8eaaaff@suse.de>
Date:   Tue, 1 Nov 2022 11:34:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 6.0 20/20] fbdev/core: Remove
 remove_conflicting_pci_framebuffers()
Content-Language: en-US
To:     "Boris V." <borisvk@bstnet.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     stable@vger.kernel.org,
        Javier Martinez Canillas <javierm@redhat.com>
References: <20221024112934.415391158@linuxfoundation.org>
 <20221024112935.205547130@linuxfoundation.org>
 <ba4caf7a-9e1f-d5fb-f20c-dba81dc00c06@bstnet.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <ba4caf7a-9e1f-d5fb-f20c-dba81dc00c06@bstnet.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------h0mgBvQ70acl4IFsbCKDwVrW"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------h0mgBvQ70acl4IFsbCKDwVrW
Content-Type: multipart/mixed; boundary="------------J8rAFomU0j005yMHUfG4G3Ix";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: "Boris V." <borisvk@bstnet.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>
Cc: stable@vger.kernel.org, Javier Martinez Canillas <javierm@redhat.com>
Message-ID: <88e835b3-4075-e1a3-9201-8ab5c8eaaaff@suse.de>
Subject: Re: [PATCH 6.0 20/20] fbdev/core: Remove
 remove_conflicting_pci_framebuffers()
References: <20221024112934.415391158@linuxfoundation.org>
 <20221024112935.205547130@linuxfoundation.org>
 <ba4caf7a-9e1f-d5fb-f20c-dba81dc00c06@bstnet.org>
In-Reply-To: <ba4caf7a-9e1f-d5fb-f20c-dba81dc00c06@bstnet.org>

--------------J8rAFomU0j005yMHUfG4G3Ix
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

KGNjOiBBbGV4IFdpbGxpYW1zb24pDQoNCkhpDQoNCkFtIDAxLjExLjIyIHVtIDA5OjQyIHNj
aHJpZWIgQm9yaXMgVi46DQo+IE9uIDI0LzEwLzIwMjIgMTM6MzEsIEdyZWcgS3JvYWgtSGFy
dG1hbiB3cm90ZToNCj4+IEZyb206IFRob21hcyBaaW1tZXJtYW5uIDx0emltbWVybWFubkBz
dXNlLmRlPg0KPj4NCj4+IGNvbW1pdCA5ZDY5ZWYxODM4MTUwYzdkODdhZmMxYTg3YWE2NThj
NjM3MjE3NTg1IHVwc3RyZWFtLg0KPj4NCj4+IFJlbW92ZSByZW1vdmVfY29uZmxpY3Rpbmdf
cGNpX2ZyYW1lYnVmZmVycygpIGFuZCBpbXBsZW1lbnQgc2ltaWxhcg0KPj4gZnVuY3Rpb25h
bGl0eSBpbiBhcGVydHVyZV9yZW1vdmVfY29uZmxpY3RpbmdfcGNpX2RldmljZSgpLCB3aGlj
aCB3YXMNCj4+IHRoZSBvbmx5IGNhbGxlci4gUmVtb3ZlcyBhbiBvdGhlcndpc2UgdW51c2Vk
IGludGVyZmFjZSBhbmQgc3RyZWFtbGluZXMNCj4+IHRoZSBhcGVydHVyZSBoZWxwZXIuIE5v
IGZ1bmN0aW9uYWwgY2hhbmdlcy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgWmlt
bWVybWFubiA8dHppbW1lcm1hbm5Ac3VzZS5kZT4NCj4+IFJldmlld2VkLWJ5OiBKYXZpZXIg
TWFydGluZXogQ2FuaWxsYXMgPGphdmllcm1AcmVkaGF0LmNvbT4NCj4+IExpbms6IA0KPj4g
aHR0cHM6Ly9wYXRjaHdvcmsuZnJlZWRlc2t0b3Aub3JnL3BhdGNoL21zZ2lkLzIwMjIwNzE4
MDcyMzIyLjg5MjctNS10emltbWVybWFubkBzdXNlLmRlDQo+PiBTaWduZWQtb2ZmLWJ5OiBH
cmVnIEtyb2FoLUhhcnRtYW4gPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0KPj4gLS0t
DQo+PiDCoCBkcml2ZXJzL3ZpZGVvL2FwZXJ0dXJlLmPCoMKgwqDCoMKgwqDCoMKgIHzCoMKg
IDMwICsrKysrKysrKysrKysrLS0tLS0tLS0tLQ0KPj4gwqAgZHJpdmVycy92aWRlby9mYmRl
di9jb3JlL2ZibWVtLmMgfMKgwqAgNDggDQo+PiAtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0NCj4+IMKgIGluY2x1ZGUvbGludXgvZmIuaMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqAgfMKgwqDCoCAyIC0NCj4+IMKgIDMgZmlsZXMgY2hhbmdlZCwgMTgg
aW5zZXJ0aW9ucygrKSwgNjIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gLS0tIGEvZHJpdmVycy92
aWRlby9hcGVydHVyZS5jDQo+PiArKysgYi9kcml2ZXJzL3ZpZGVvL2FwZXJ0dXJlLmMNCj4+
IEBAIC0zMzUsMzAgKzMzNSwzNiBAQCBFWFBPUlRfU1lNQk9MKGFwZXJ0dXJlX3JlbW92ZV9j
b25mbGljdGluDQo+PiDCoMKgICovDQo+PiDCoCBpbnQgYXBlcnR1cmVfcmVtb3ZlX2NvbmZs
aWN0aW5nX3BjaV9kZXZpY2VzKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCANCj4+IGNvbnN0IGNo
YXIgKm5hbWUpDQo+PiDCoCB7DQo+PiArwqDCoMKgIGJvb2wgcHJpbWFyeSA9IGZhbHNlOw0K
Pj4gwqDCoMKgwqDCoCByZXNvdXJjZV9zaXplX3QgYmFzZSwgc2l6ZTsNCj4+IMKgwqDCoMKg
wqAgaW50IGJhciwgcmV0Ow0KPj4gLcKgwqDCoCAvKg0KPj4gLcKgwqDCoMKgICogV0FSTklO
RzogQXBwYXJlbnRseSB3ZSBtdXN0IGtpY2sgZmJkZXYgZHJpdmVycyBiZWZvcmUgdmdhY29u
LA0KPj4gLcKgwqDCoMKgICogb3RoZXJ3aXNlIHRoZSB2Z2EgZmJkZXYgZHJpdmVyIGZhbGxz
IG92ZXIuDQo+PiAtwqDCoMKgwqAgKi8NCj4+IC0jaWYgSVNfUkVBQ0hBQkxFKENPTkZJR19G
QikNCj4+IC3CoMKgwqAgcmV0ID0gcmVtb3ZlX2NvbmZsaWN0aW5nX3BjaV9mcmFtZWJ1ZmZl
cnMocGRldiwgbmFtZSk7DQo+PiAtwqDCoMKgIGlmIChyZXQpDQo+PiAtwqDCoMKgwqDCoMKg
wqAgcmV0dXJuIHJldDsNCj4+ICsjaWZkZWYgQ09ORklHX1g4Ng0KPj4gK8KgwqDCoCBwcmlt
YXJ5ID0gcGRldi0+cmVzb3VyY2VbUENJX1JPTV9SRVNPVVJDRV0uZmxhZ3MgJiANCj4+IElP
UkVTT1VSQ0VfUk9NX1NIQURPVzsNCj4+IMKgICNlbmRpZg0KPj4gLcKgwqDCoCByZXQgPSB2
Z2FfcmVtb3ZlX3ZnYWNvbihwZGV2KTsNCj4+IC3CoMKgwqAgaWYgKHJldCkNCj4+IC3CoMKg
wqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4gwqDCoMKgwqDCoCBmb3IgKGJhciA9IDA7IGJh
ciA8IFBDSV9TVERfTlVNX0JBUlM7ICsrYmFyKSB7DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAg
aWYgKCEocGNpX3Jlc291cmNlX2ZsYWdzKHBkZXYsIGJhcikgJiBJT1JFU09VUkNFX01FTSkp
DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBjb250aW51ZTsNCj4+ICsNCj4+IMKg
wqDCoMKgwqDCoMKgwqDCoCBiYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIGJhcik7
DQo+PiDCoMKgwqDCoMKgwqDCoMKgwqAgc2l6ZSA9IHBjaV9yZXNvdXJjZV9sZW4ocGRldiwg
YmFyKTsNCj4+IC3CoMKgwqDCoMKgwqDCoCBhcGVydHVyZV9kZXRhY2hfZGV2aWNlcyhiYXNl
LCBzaXplKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCByZXQgPSBhcGVydHVyZV9yZW1vdmVfY29u
ZmxpY3RpbmdfZGV2aWNlcyhiYXNlLCBzaXplLCANCj4+IHByaW1hcnksIG5hbWUpOw0KPj4g
K8KgwqDCoMKgwqDCoMKgIGlmIChyZXQpDQo+PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBi
cmVhazsNCj4+IMKgwqDCoMKgwqAgfQ0KPj4gK8KgwqDCoCBpZiAocmV0KQ0KPj4gK8KgwqDC
oMKgwqDCoMKgIHJldHVybiByZXQ7DQo+PiArDQo+PiArwqDCoMKgIC8qDQo+PiArwqDCoMKg
wqAgKiBXQVJOSU5HOiBBcHBhcmVudGx5IHdlIG11c3Qga2ljayBmYmRldiBkcml2ZXJzIGJl
Zm9yZSB2Z2Fjb24sDQo+PiArwqDCoMKgwqAgKiBvdGhlcndpc2UgdGhlIHZnYSBmYmRldiBk
cml2ZXIgZmFsbHMgb3Zlci4NCj4+ICvCoMKgwqDCoCAqLw0KPj4gK8KgwqDCoCByZXQgPSB2
Z2FfcmVtb3ZlX3ZnYWNvbihwZGV2KTsNCj4+ICvCoMKgwqAgaWYgKHJldCkNCj4+ICvCoMKg
wqDCoMKgwqDCoCByZXR1cm4gcmV0Ow0KPj4gKw0KPj4gwqDCoMKgwqDCoCByZXR1cm4gMDsN
Cj4+IMKgIH0NCj4+IC0tLSBhL2RyaXZlcnMvdmlkZW8vZmJkZXYvY29yZS9mYm1lbS5jDQo+
PiArKysgYi9kcml2ZXJzL3ZpZGVvL2ZiZGV2L2NvcmUvZmJtZW0uYw0KPj4gQEAgLTE3ODgs
NTQgKzE3ODgsNiBAQCBpbnQgcmVtb3ZlX2NvbmZsaWN0aW5nX2ZyYW1lYnVmZmVycyhzdHJ1
DQo+PiDCoCBFWFBPUlRfU1lNQk9MKHJlbW92ZV9jb25mbGljdGluZ19mcmFtZWJ1ZmZlcnMp
Ow0KPj4gwqAgLyoqDQo+PiAtICogcmVtb3ZlX2NvbmZsaWN0aW5nX3BjaV9mcmFtZWJ1ZmZl
cnMgLSByZW1vdmUgZmlybXdhcmUtY29uZmlndXJlZCANCj4+IGZyYW1lYnVmZmVycyBmb3Ig
UENJIGRldmljZXMNCj4+IC0gKiBAcGRldjogUENJIGRldmljZQ0KPj4gLSAqIEBuYW1lOiBy
ZXF1ZXN0aW5nIGRyaXZlciBuYW1lDQo+PiAtICoNCj4+IC0gKiBUaGlzIGZ1bmN0aW9uIHJl
bW92ZXMgZnJhbWVidWZmZXIgZGV2aWNlcyAoZWcuIGluaXRpYWxpemVkIGJ5IA0KPj4gZmly
bXdhcmUpDQo+PiAtICogdXNpbmcgbWVtb3J5IHJhbmdlIGNvbmZpZ3VyZWQgZm9yIGFueSBv
ZiBAcGRldidzIG1lbW9yeSBiYXJzLg0KPj4gLSAqDQo+PiAtICogVGhlIGZ1bmN0aW9uIGFz
c3VtZXMgdGhhdCBQQ0kgZGV2aWNlIHdpdGggc2hhZG93ZWQgUk9NIGRyaXZlcyBhIA0KPj4g
cHJpbWFyeQ0KPj4gLSAqIGRpc3BsYXkgYW5kIHNvIGtpY2tzIG91dCB2Z2ExNmZiLg0KPj4g
LSAqLw0KPj4gLWludCByZW1vdmVfY29uZmxpY3RpbmdfcGNpX2ZyYW1lYnVmZmVycyhzdHJ1
Y3QgcGNpX2RldiAqcGRldiwgY29uc3QgDQo+PiBjaGFyICpuYW1lKQ0KPj4gLXsNCj4+IC3C
oMKgwqAgc3RydWN0IGFwZXJ0dXJlc19zdHJ1Y3QgKmFwOw0KPj4gLcKgwqDCoCBib29sIHBy
aW1hcnkgPSBmYWxzZTsNCj4+IC3CoMKgwqAgaW50IGVyciwgaWR4LCBiYXI7DQo+PiAtDQo+
PiAtwqDCoMKgIGZvciAoaWR4ID0gMCwgYmFyID0gMDsgYmFyIDwgUENJX1NURF9OVU1fQkFS
UzsgYmFyKyspIHsNCj4+IC3CoMKgwqDCoMKgwqDCoCBpZiAoIShwY2lfcmVzb3VyY2VfZmxh
Z3MocGRldiwgYmFyKSAmIElPUkVTT1VSQ0VfTUVNKSkNCj4+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgIGNvbnRpbnVlOw0KPj4gLcKgwqDCoMKgwqDCoMKgIGlkeCsrOw0KPj4gLcKgwqDC
oCB9DQo+PiAtDQo+PiAtwqDCoMKgIGFwID0gYWxsb2NfYXBlcnR1cmVzKGlkeCk7DQo+PiAt
wqDCoMKgIGlmICghYXApDQo+PiAtwqDCoMKgwqDCoMKgwqAgcmV0dXJuIC1FTk9NRU07DQo+
PiAtDQo+PiAtwqDCoMKgIGZvciAoaWR4ID0gMCwgYmFyID0gMDsgYmFyIDwgUENJX1NURF9O
VU1fQkFSUzsgYmFyKyspIHsNCj4+IC3CoMKgwqDCoMKgwqDCoCBpZiAoIShwY2lfcmVzb3Vy
Y2VfZmxhZ3MocGRldiwgYmFyKSAmIElPUkVTT1VSQ0VfTUVNKSkNCj4+IC3CoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIGNvbnRpbnVlOw0KPj4gLcKgwqDCoMKgwqDCoMKgIGFwLT5yYW5nZXNb
aWR4XS5iYXNlID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIGJhcik7DQo+PiAtwqDCoMKg
wqDCoMKgwqAgYXAtPnJhbmdlc1tpZHhdLnNpemUgPSBwY2lfcmVzb3VyY2VfbGVuKHBkZXYs
IGJhcik7DQo+PiAtwqDCoMKgwqDCoMKgwqAgcGNpX2RiZyhwZGV2LCAiJXM6IGJhciAlZDog
MHglbHggLT4gMHglbHhcbiIsIF9fZnVuY19fLCBiYXIsDQo+PiAtwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCAodW5zaWduZWQgbG9uZylwY2lfcmVzb3VyY2Vfc3RhcnQocGRldiwgYmFyKSwN
Cj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgICh1bnNpZ25lZCBsb25nKXBjaV9yZXNvdXJj
ZV9lbmQocGRldiwgYmFyKSk7DQo+PiAtwqDCoMKgwqDCoMKgwqAgaWR4Kys7DQo+PiAtwqDC
oMKgIH0NCj4+IC0NCj4+IC0jaWZkZWYgQ09ORklHX1g4Ng0KPj4gLcKgwqDCoCBwcmltYXJ5
ID0gcGRldi0+cmVzb3VyY2VbUENJX1JPTV9SRVNPVVJDRV0uZmxhZ3MgJg0KPj4gLcKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIElPUkVTT1VSQ0VfUk9NX1NIQURP
VzsNCj4+IC0jZW5kaWYNCj4+IC3CoMKgwqAgZXJyID0gcmVtb3ZlX2NvbmZsaWN0aW5nX2Zy
YW1lYnVmZmVycyhhcCwgbmFtZSwgcHJpbWFyeSk7DQo+PiAtwqDCoMKgIGtmcmVlKGFwKTsN
Cj4+IC3CoMKgwqAgcmV0dXJuIGVycjsNCj4+IC19DQo+PiAtRVhQT1JUX1NZTUJPTChyZW1v
dmVfY29uZmxpY3RpbmdfcGNpX2ZyYW1lYnVmZmVycyk7DQo+PiAtDQo+PiAtLyoqDQo+PiDC
oMKgICrCoMKgwqAgcmVnaXN0ZXJfZnJhbWVidWZmZXIgLSByZWdpc3RlcnMgYSBmcmFtZSBi
dWZmZXIgZGV2aWNlDQo+PiDCoMKgICrCoMKgwqAgQGZiX2luZm86IGZyYW1lIGJ1ZmZlciBp
bmZvIHN0cnVjdHVyZQ0KPj4gwqDCoCAqDQo+PiAtLS0gYS9pbmNsdWRlL2xpbnV4L2ZiLmgN
Cj4+ICsrKyBiL2luY2x1ZGUvbGludXgvZmIuaA0KPj4gQEAgLTYxNSw4ICs2MTUsNiBAQCBl
eHRlcm4gc3NpemVfdCBmYl9zeXNfd3JpdGUoc3RydWN0IGZiX2luDQo+PiDCoCAvKiBkcml2
ZXJzL3ZpZGVvL2ZibWVtLmMgKi8NCj4+IMKgIGV4dGVybiBpbnQgcmVnaXN0ZXJfZnJhbWVi
dWZmZXIoc3RydWN0IGZiX2luZm8gKmZiX2luZm8pOw0KPj4gwqAgZXh0ZXJuIHZvaWQgdW5y
ZWdpc3Rlcl9mcmFtZWJ1ZmZlcihzdHJ1Y3QgZmJfaW5mbyAqZmJfaW5mbyk7DQo+PiAtZXh0
ZXJuIGludCByZW1vdmVfY29uZmxpY3RpbmdfcGNpX2ZyYW1lYnVmZmVycyhzdHJ1Y3QgcGNp
X2RldiAqcGRldiwNCj4+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgIGNvbnN0IGNoYXIgKm5hbWUpOw0KPj4gwqAgZXh0ZXJuIGludCBy
ZW1vdmVfY29uZmxpY3RpbmdfZnJhbWVidWZmZXJzKHN0cnVjdCBhcGVydHVyZXNfc3RydWN0
ICphLA0KPj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgIGNvbnN0IGNoYXIgKm5hbWUsIGJvb2wgcHJpbWFyeSk7DQo+PiDCoCBleHRlcm4gaW50
IGZiX3ByZXBhcmVfbG9nbyhzdHJ1Y3QgZmJfaW5mbyAqZmJfaW5mbywgaW50IHJvdGF0ZSk7
DQo+Pg0KPj4NCj4+DQo+Pg0KPiANCj4gSGVsbG8sDQo+IA0KPiB0aGlzIHBhdGNoIHNlZW1z
IHRvIGRpc2FibGUgY29uc29sZS9mcmFtZWJ1ZmZlciB3aGVuIHZmaW8tcGNpIGlzIHVzZWQu
DQo+IEkgaGF2YSAyIG52aWRpYSBHUFVzIG9uZSBpcyB1c2VkIGZvciBob3N0IGFuZCBvdGhl
ciBpcyBwYXNzZWQgdGhyb3VnaCB0byANCj4gVk0uDQoNClZmaW8gdXNlcyB0aGlzIGhlbHBl
ciB0byB1bmxvYWQgdGhlIGRyaXZlciBiZWZvcmUgcGFzc2luZyBpdCB0byBhIFZNIA0KQUZB
SVUuIEJ1dCB1bmxlc3MgeW91J3JlIHVzaW5nIG5vdXZlYXUsIHlvdSdyZSBvbiB5b3VyIG93
bi4NCg0KQmVzdCByZWdhcmRzDQpUaG9tYXMNCg0KPiBOb3cgYWZ0ZXIgdGhpcyBwYXRjaCwg
d2hlbiB2ZmlvLXBjaSBtb2R1bGUgaXMgbG9hZGVkIHdpdGggcGFyYW1ldGVyIA0KPiBpZHM9
MTBkZToyNDg2LDEwZGU6MjI4YiwNCj4gY29uc29sZSBpcyBsb3N0L2Zyb3plbiwgbGFzdCBt
ZXNzYWdlIGlzIHRoYXQgdmZpby1wY2kgbW9kdWxlIHdhcyBsb2FkZWQgDQo+IGFuZCB0aGVu
IHRoZXJlIGlzIG5vIG1vcmUgb3V0cHV0Lg0KPiBUaGlzIFBDSSBJRHMgKDEwZGU6MjQ4Niwx
MGRlOjIyOGIpIGFyZSBmb3Igc2Vjb25kYXJ5IEdQVSwgcHJpbWFyeS9ib290IA0KPiBHUFUg
aXMgdXNlZCBmb3IgaG9zdCBhbmQgYm9vdCBtZXNzYWdlcyBhcmUgZGlzcGxheWVkIG9uIHBy
aW1hcnkvYm9vdCBHUFUuDQo+IA0KPiBVc2luZyBkbWVzZyBJIHNlZSB0aGlzIG1lc3NhZ2Vz
IGFmdGVyIHZmaW8tcGNpIGlzIGxvYWRlZDoNCj4gDQo+IFvCoMKgwqAgMy45OTM2MDFdIFZG
SU8gLSBVc2VyIExldmVsIG1ldGEtZHJpdmVyIHZlcnNpb246IDAuMw0KPiBbwqDCoMKgIDQu
MDIwMjM5XSBDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3VyIGR1bW15IGRldmljZSA4MHgy
NQ0KPiBbwqDCoMKgIDQuMDIwMzM1XSB2ZmlvLXBjaSAwMDAwOjFhOjAwLjA6IHZnYWFyYjog
Y2hhbmdlZCBWR0EgZGVjb2RlczogDQo+IG9sZGRlY29kZXM9aW8rbWVtLGRlY29kZXM9bm9u
ZTpvd25zPW5vbmUNCj4gW8KgwqDCoCA0LjAyMDcyMl0gdmZpb19wY2k6IGFkZCBbMTBkZToy
NDg2W2ZmZmZmZmZmOmZmZmZmZmZmXV0gY2xhc3MgDQo+IDB4MDAwMDAwLzAwMDAwMDAwDQo+
IFvCoMKgwqAgNC4xMTY2MTZdIHZmaW9fcGNpOiBhZGQgWzEwZGU6MjI4YltmZmZmZmZmZjpm
ZmZmZmZmZl1dIGNsYXNzIA0KPiAweDAwMDAwMC8wMDAwMDAwMA0KPiANCj4gSSBndWVzcyB0
aGUgcHJvYmxlbSBoZXJlIGlzICJDb25zb2xlOiBzd2l0Y2hpbmcgdG8gY29sb3VyIGR1bW15
IGRldmljZSANCj4gODB4MjUiLCBidXQgSSBkb24ndCBrbm93IHdoeSB0aGlzIGhhcHBlbnMu
DQo+IExhc3Qgd29ya2luZyBrZXJuZWwgaXMgNi4wLjMsIGFmdGVyIHVwZ3JhZGluZyB0byA2
LjAuNCAoYW5kIDYuMC41LCANCj4gNi4wLjYpLCBjb25zb2xlIGlzIG5vIGxvbmdlciB3b3Jr
aW5nLg0KPiBCeSBnaXQgYmlzZWN0aW5nIGl0IHNlZW1zIGJhZCBjb21taXQgaXMgDQo+IGFm
OWFjNTQxZTg4MzkwZDk3YjAxZDVlOGM3NzMwOWQyNjM3YzFkNGMuDQo+IA0KDQotLSANClRo
b21hcyBaaW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3
YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJu
YmVyZywgR2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bD
vGhyZXI6IEl2byBUb3Rldg0K

--------------J8rAFomU0j005yMHUfG4G3Ix--

--------------h0mgBvQ70acl4IFsbCKDwVrW
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNg9joFAwAAAAAACgkQlh/E3EQov+AW
ug/7Be5/IQQY0pCfid9qZDCC/baHZaWbcvOM6U9yd03mdDavtKP/sDkvWvZgWuS+698pUIpLUyx1
Mbp7Ig3HbdLprQD64S1QKhMPdQrO4sjWHm67fV2B39gjJNvqRO1owi+iB/PG5DiB88j1kfcwVSOi
gppW6OVYkG76IQiKys2Qv7XRe7CtoggPWO6ixI91ITapJ9hftOHw9HYEEaL00Zb5S3ZFfe4U/3Fm
yRtX06mhOMl0PSMkDpnD0eChFUuwnek5yAQnZpYmqp8JKGguV7d7pCzPthnr0yrDN4BPR1NXAg/I
jbmS6Dl8TOxzL1ew41SdBgIGFd7+h/K76o+wFa+dg4uk+txH3KA2UBheQJqKxIllNHGzAHJBAppg
caFBlY7Fq0QNptCzv5coqqThqAti+zIdjKZu7CM5fNUzZcwM5lzH92PrxH+PcXTVd4izTd8ilJmO
XRWzylpujppc1rm311u+w48uyz0u22dqFBHhWcGwrTL7ujkfDXtPN5vBTYdqn/WfhcVIyj2iEfnT
YtDJjrkuYsuYXivRcA1JrXnLcXWc5BLgcasR7EJ2WdgFLmoOczCF3NXL857JnTWh+crEuFPQb7zp
8n3DRXDUTeWDI/36A6F4viAwk4Auxi8srwPZaO340tz/7abbZhyNhCX+k2zucoLJk6Gb4RqRH6M4
WCQ=
=UHMO
-----END PGP SIGNATURE-----

--------------h0mgBvQ70acl4IFsbCKDwVrW--
