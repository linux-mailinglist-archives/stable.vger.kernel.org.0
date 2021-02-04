Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D09EB310113
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 00:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhBDXwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 18:52:54 -0500
Received: from mout.gmx.net ([212.227.15.15]:56695 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231239AbhBDXwx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Feb 2021 18:52:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1612482671;
        bh=VQUCkj7jIWOGve7JPw0DV8vIa6RGd9aNey65ZHgCELo=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=Ma/F0U0xvpFdwhc43hAADfx3GYy9MHvu5VxooQbggxXNDtfox06KamLFsxoQEcZjy
         Yg69v9uijpdz7RzdTtMSJR4cAagsc6vz0zMP/5T+OPE+M0b+FfETQ6wC2Wm8eP3jT/
         dGtMnk6RpDxWpnklMgQhrAvvRItt3ZtzdLJmdyQw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from Venus.fritz.box ([78.42.220.31]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MpDJd-1liqdU0Elb-00qm9S; Fri, 05
 Feb 2021 00:51:11 +0100
From:   Lino Sanfilippo <LinoSanfilippo@gmx.de>
To:     peterhuewe@gmx.de, jarkko@kernel.org
Cc:     jgg@ziepe.ca, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        LinoSanfilippo@gmx.de
Subject: [PATCH v3 0/2] TPM fixes
Date:   Fri,  5 Feb 2021 00:50:41 +0100
Message-Id: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Transfer-Encoding: base64
X-Provags-ID: V03:K1:z0+rthG6Pi9DyXxgJQtfhhNQPMTS82SH+kJInh2dypDqI9tD26P
 l4cuciqxN6NZXF1YEffCF03dcW+k+IDjEMpVzn2SY8vA0a/pNY/XzbkVd8WIjA+f939G6+L
 WeQK2eEhoWEPmpVNdn0DZ96XYw4hMVU6ykw8xn3SIMr1v01HIRfJtC1HF+XEZfVJRU5H0Zg
 C5EjzoW8SLHlj5KFEhYUg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UYQph2jlBp0=:RvqRfqSNs/pqbFDy9B67zv
 KqMEVvgaBRs3gcOVnvN957oTfYuODhcJIuOGwWdmnMh9pSXOl4HOv0pJVqi4J7Et6lbwJm1U3
 jeuV2hDbu5J5w6che9HvtoFo78AUAF2XFV3JDbT0OYtDtWe7WpumUGOqO6pvXcaMN6gD6We6l
 /X7Hv5tKMbteDByXzIAU7pNn/E6Lb0qpebJhLAsVkis4Digag6FgTZfocikEgQ0TiRT9UiasO
 iY3RJbZTx2zeHu7xm9Bx2W3CtwqLY732+Ft0jVUVdKYiWcNrrnYpyaJs2T6WPRPbiKxq9H7lI
 Wwq0yF+J2OjarSr32Ynm4o/h1IRvDKR2XUwzEEM4vqHhBliFf1rK0xcyvXSsrcUj2+8Q7hYoT
 aspxtqzGZCkR2uo8kFT6qKq6UdV2HNvvwTLt9EVByn4Vs+AafWFWPhhRH0kPr1xoV2jpLgQdx
 oTe2/y9U5NYARWnW4mrUuNCy2HfDu/PbYJgwQd28Ug2/RFPyMq67yUYCTdZrI3emhhcr3OGLV
 gxLIawdDPnPPynivy64htuFaOQgdcKuXoDrlunGgz/Mwt0IuD4gUFBoWPeJkRKO444tLR6gni
 nBBKLGWvczxXPVA9PWvDlLNVofyGIefrcn6xtFuIeiUrJNOgmXp/YkUSICVfF5l5s1QqLyUVn
 U1WuZQJh0LFmE7xGZzbIKQKym0KkflCbw4NevYh0kPQG8u32TlvemcnFP2miAk294wVbbLSuM
 ZS/Mnxj5t/TZ6StDEb5ZXaokZVEgGwABsXcSabns/Ap+qS8MF/BSXbdhpIIJ0WpSZGh+iG5TK
 m28D5/tU+4cP26AMvsGVszFKTCS9ysz8K2iPcDJHHdWVlXwx8BvMokEjhq9q8+HQ9T5JDAxVp
 ot0Yhs6wM9lBaSirLtLg==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Q2hhbmdlcyBpbiB2MwotIGRyb3AgdGhlIHBhdGNoIHRoYXQgaW50cm9kdWNlcyB0aGUgbmV3IGZ1
bmN0aW9uIHRwbV9jaGlwX2ZyZWUoKQotIHJld29yayB0aGUgY29tbWl0IG1lc3NhZ2VzIGZvciB0
aGUgcGF0Y2hlcyAoc3R5bGUsIHR5cG9zLCBldGMuKQotIGFkZCBmaXhlcyB0YWcgdG8gcGF0Y2gg
MgotIGFkZCBKYW1lcyBCb3R0b21sZXkgdG8gY2MgbGlzdAotIGFkZCBzdGFibGUgbWFpbGluZyBs
aXN0IHRvIGNjIGxpc3QKCkNoYW5nZXMgaW4gdjI6Ci0gZHJvcCB0aGUgcGF0Y2ggdGhhdCBlcnJv
bmVvdXNseSBjbGVhbmVkIHVwIGFmdGVyIGZhaWxlZCBpbnN0YWxsYXRpb24gb2YKICBhbiBhY3Rp
b24gaGFuZGxlciBpbiB0cG1tX2NoaXBfYWxsb2MoKSAocG9pbnRlZCBvdXQgYnkgSmFya2tvIFNh
a2tpbmVuKQotIG1ha2UgdGhlIGNvbW1pdCBtZXNzYWdlIGZvciBwYXRjaCAxIG1vcmUgZGV0YWls
ZWQKLSBhZGQgZml4ZXMgdGFncyBhbmQga2VybmVsIGxvZ3MKCkxpbm8gU2FuZmlsaXBwbyAoMik6
CiAgdHBtOiBmaXggcmVmZXJlbmNlIGNvdW50aW5nIGZvciBzdHJ1Y3QgdHBtX2NoaXAKICB0cG06
IGluIHRwbTJfZGVsX3NwYWNlIGNoZWNrIGlmIG9wcyBwb2ludGVyIGlzIHN0aWxsIHZhbGlkCgog
ZHJpdmVycy9jaGFyL3RwbS90cG0tY2hpcC5jICAgICAgIHwgMTggKysrKysrKysrKysrKysrLS0t
CiBkcml2ZXJzL2NoYXIvdHBtL3RwbTItc3BhY2UuYyAgICAgfCAxNSArKysrKysrKysrLS0tLS0K
IGRyaXZlcnMvY2hhci90cG0vdHBtX2Z0cG1fdGVlLmMgICB8ICAyICsrCiBkcml2ZXJzL2NoYXIv
dHBtL3RwbV92dHBtX3Byb3h5LmMgfCAgMSArCiA0IGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlv
bnMoKyksIDggZGVsZXRpb25zKC0pCgotLSAKMi43LjQKCg==
