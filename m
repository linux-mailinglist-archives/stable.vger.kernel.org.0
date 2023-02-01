Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3BB6867A6
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 14:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbjBANxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 08:53:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjBANxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 08:53:14 -0500
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356A568102;
        Wed,  1 Feb 2023 05:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=Ey2T6fTYwqEkFYh1QlALPkP41Bi4rCz6ll/b6xek2/E=; b=QkDxZlxUHFtZUekwWQfoqUwTJz
        aA2GKDVKYEAf6KSWilUnrBYI1wCCNIXNgJSXHMPHjGGIEmEFSWyol+2Q/tXruNv86T+sZl9zAMQPx
        LDs6EvgOD6ZjtuClMeRjcSbr6fUmKagteZ9G+iXCwgW/DAqnwcZ6wftnTGvo7pzfkePrR45iFjnJq
        3XgE8+Thw2Wz47305nME9l9uQDEk3eFCkUe9Dfs89KH3VJMdHgPjFvEtdUblafeyS+tQamVeIR7av
        smEpPdshEoY8+Gld5NdmUzuI9Msn2C7m8GoaRYn3z7UsPC7hi7PtgKbWiSenVfBHqeeYAzzM1XlWl
        wllLtjr0tGmjTb38spjctCpgiw5lwFPz3eWjSiDn6gM7xpqUspMWzpycF7CQ8WtlTsLsF1PTJMdyZ
        kwoV9C3XP7D6oxtz4EBN+eocYPt3377C8gyxct/eHOhhHIMhIjPrFoxj0za8i4qPsbJBZv1h8K81H
        OjqAmprag82q4PbXsKkrZ/EU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1pNDXY-00BEzF-IA; Wed, 01 Feb 2023 13:52:44 +0000
Message-ID: <2e190648-a69e-9dc4-a765-8b5bc4ce528b@samba.org>
Date:   Wed, 1 Feb 2023 14:52:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 0/3] avoid plaintext rdma offset if encryption is required
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>, stable@vger.kernel.org
References: <cover.1675252643.git.metze@samba.org>
 <Y9prn4niNung9Zer@infradead.org>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <Y9prn4niNung9Zer@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

QW0gMDEuMDIuMjMgdW0gMTQ6Mzkgc2NocmllYiBDaHJpc3RvcGggSGVsbHdpZzoNCj4gT24g
V2VkLCBGZWIgMDEsIDIwMjMgYXQgMDE6MDQ6NDBQTSArMDEwMCwgU3RlZmFuIE1ldHptYWNo
ZXIgd3JvdGU6DQo+PiBJIHRoaW5rIGl0IGlzIGEgc2VjdXJpdHkgcHJvYmxlbSB0byBzZW5k
IGNvbmZpZGVudGlhbCBkYXRhIGluIHBsYWludGV4dA0KPj4gb3ZlciB0aGUgd2lyZSwgc28g
d2Ugc2hvdWxkIGF2b2lkIGRvaW5nIHRoYXQgZXZlbiBpZiByZG1hIGlzIGluIHVzZS4NCj4g
DQo+IFllcC4NCj4gDQo+PiBNb2Rlcm4gV2luZG93cyBzZXJ2ZXJzIHN1cHBvcnQgc2lnbmVk
IGFuZCBlbmNyeXB0ZWQgcmRtYSBvZmZsb2FkLA0KPj4gYnV0IHdlIGRvbid0IHN1cHBvcnQg
dGhpcyB5ZXQuLi4NCj4gDQo+IFRoZXJlIGlzIGEgc2VyaWVzIG91dCBvbiB0aGUgbGlzdCBm
b3IgZW5jcnlwdGlvbiBvZmZsb2FkIHRvIG1seDUNCj4gaGFyZHdhcmUsIHdoY2ggaXMgb25l
IHdheSB0byBoYW5kbGUgdGhpcy4gIElmIG5vdCB5b3UgbmVlZCB0byBib3VuY2UNCj4gYnVm
ZmVyLg0KDQpZZXMsIEkgc2F3IHRoYXQsIGJ1dCBJIGRvbid0IHRoaW5rIGl0J3MgdXNhYmxl
LCB3aW5kb3dzIGlzIHVzaW5nDQphZXMtezEyOCwyNTZ9LXtnY20sY2NtfS4uLg0KDQptZXR6
ZQ0K
