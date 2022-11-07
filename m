Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40D862040D
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 00:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiKGXzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 18:55:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiKGXzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 18:55:44 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFC527B08;
        Mon,  7 Nov 2022 15:55:41 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id l12so7823985lfp.6;
        Mon, 07 Nov 2022 15:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uYpG5kIVjDW6gUzmyqnTmwzAvBCwOte6nMdhHbBsYiM=;
        b=kweB4LEI5apssc+vdQrfozDq0gau5l6+I53kgzgOAHJrzazoB1Wm/SeyQfS+br4H4/
         lFbgvjSLnk8g6k4aH+HQFWT4Vm+uIxMTmja9OTh0x/d5kOwop+ZDwkdwNHRJRRZAXqST
         qml/67j7av93HVQnKzUIkI4/sDQpfIGW2HnEei2dHHwwGcPfWt7l7/hd6DpyeCc8N7yq
         WFXnBJV3kSgM0mzeFRSVoIEdmGPKbbUneetGpSIT7ZQ3HBgxJlcdaUN6+PkrB4tASl+W
         89Mr7gcwVuSf8Xtd4YJX1bm9DlFAYCY0PaCvRWFXQhHkUd6hEu0esTpiopH3Pk7RQvbH
         4DbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uYpG5kIVjDW6gUzmyqnTmwzAvBCwOte6nMdhHbBsYiM=;
        b=L4VkMhcZsLGcNKmbK+HUDUXW+YnZPIDrPPoVrEhLnVHVcPs8yAGRB/2kDoJOUOxZvN
         2Xjlp4JBGJIj8nB8Eo8MuH/t0OoTLjXoJPzY5q579HiobkObYYtTnEeEyq86K8tdd1p8
         YdZbGQKMszC8VcmmdJXKLzSFaOYwpF8RZ29dXw5jnLD7dvR5leGWrcJCqCzcPBz4/5cn
         SBq0Qlh9XTPU/4c9MSCgYVvKUsMzwH6+I+bw2reAdvAKcP9r1+QyAqc/yrtPTXiG+s4S
         t2K02Z4MbU4XRiKOE6tXRiAa6fUzW0s8L1gxWunglI4flZYTW8A0PLZLfSFAv8OcbPbO
         d5xA==
X-Gm-Message-State: ACrzQf1ZR1MG+EcOvt824bGCC+LDxLLLIJeOvCQ9+n7r4WsueXW3kzWC
        Cf3UcvBwrFJsXa5CqbrtzMlbB/HOsSrzwG5Lt7m4mWMO
X-Google-Smtp-Source: AMsMyM6uvxUMtRV2MUGugvUxU+agHp//UGoqCPruQEdbIk1tKuDNYIicX9p8nC/sDIjzMYKOvVrwqIyp3oH023i4m90=
X-Received: by 2002:a05:6512:3c90:b0:4a2:5168:b410 with SMTP id
 h16-20020a0565123c9000b004a25168b410mr19799108lfv.163.1667865338897; Mon, 07
 Nov 2022 15:55:38 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mub3G42yb48gN-KY7tgqen8oeT-mmE7y23vyQ0e5ihctQ@mail.gmail.com>
In-Reply-To: <CAH2r5mub3G42yb48gN-KY7tgqen8oeT-mmE7y23vyQ0e5ihctQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 7 Nov 2022 17:55:27 -0600
Message-ID: <CAH2r5muthiUdk9Lgt5noXLZo4Kkh25VmF1x9mFnWtFVqXxAoyw@mail.gmail.com>
Subject: Fwd: patch for stable "cifs: fix regression in very old smb1 mounts"
To:     Stable <stable@vger.kernel.org>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000000f2e0e05ecea29e8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000000f2e0e05ecea29e8
Content-Type: text/plain; charset="UTF-8"

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Mon, Nov 7, 2022 at 5:54 PM
Subject: patch for stable "cifs: fix regression in very old smb1 mounts"
To: Stable <stable@vger.kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, Thorsten Leemhuis
<regressions@leemhuis.info>, ronnie sahlberg
<ronniesahlberg@gmail.com>


commit 2f6f19c7aaad "cifs: fix regression in very old smb1 mounts" upstream

Also attached upstream commit.

For 5.15 and 6.0 stable kernels





-- 
Thanks,

Steve


-- 
Thanks,

Steve

--0000000000000f2e0e05ecea29e8
Content-Type: application/x-patch; 
	name="0001-cifs-fix-regression-in-very-old-smb1-mounts.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-fix-regression-in-very-old-smb1-mounts.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_la7fwc7i0>
X-Attachment-Id: f_la7fwc7i0

RnJvbSAyZjZmMTljN2FhYWQ1MDA1ZGM3NTI5OGE0MTNlYjAyNDNjNWQzMTJkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBSb25uaWUgU2FobGJlcmcgPGxzYWhsYmVyQHJlZGhhdC5jb20+
CkRhdGU6IFdlZCwgMTIgT2N0IDIwMjIgMDk6MTI6MDcgKzEwMDAKU3ViamVjdDogW1BBVENIXSBj
aWZzOiBmaXggcmVncmVzc2lvbiBpbiB2ZXJ5IG9sZCBzbWIxIG1vdW50cwoKQlo6IDIxNTM3NQoK
Rml4ZXM6IDc2YTNjOTJlYzllMCAoImNpZnM6IHJlbW92ZSBzdXBwb3J0IGZvciBOVExNIGFuZCB3
ZWFrZXIgYXV0aGVudGljYXRpb24gYWxnb3JpdGhtcyIpClJldmlld2VkLWJ5OiBQYXVsbyBBbGNh
bnRhcmEgKFNVU0UpIDxwY0BjanIubno+ClNpZ25lZC1vZmYtYnk6IFJvbm5pZSBTYWhsYmVyZyA8
bHNhaGxiZXJAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogU3RldmUgRnJlbmNoIDxzdGZyZW5j
aEBtaWNyb3NvZnQuY29tPgotLS0KIGZzL2NpZnMvY29ubmVjdC5jIHwgMTEgKysrKystLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCA0MDkwMGFh
Y2U0MTYuLmUxNTgyNTdkYTFjZCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysrIGIv
ZnMvY2lmcy9jb25uZWN0LmMKQEAgLTM5MjIsMTIgKzM5MjIsMTEgQEAgQ0lGU1RDb24oY29uc3Qg
dW5zaWduZWQgaW50IHhpZCwgc3RydWN0IGNpZnNfc2VzICpzZXMsCiAJcFNNQi0+QW5kWENvbW1h
bmQgPSAweEZGOwogCXBTTUItPkZsYWdzID0gY3B1X3RvX2xlMTYoVENPTl9FWFRFTkRFRF9TRUNJ
TkZPKTsKIAliY2NfcHRyID0gJnBTTUItPlBhc3N3b3JkWzBdOwotCWlmICh0Y29uLT5waXBlIHx8
IChzZXMtPnNlcnZlci0+c2VjX21vZGUgJiBTRUNNT0RFX1VTRVIpKSB7Ci0JCXBTTUItPlBhc3N3
b3JkTGVuZ3RoID0gY3B1X3RvX2xlMTYoMSk7CS8qIG1pbmltdW0gKi8KLQkJKmJjY19wdHIgPSAw
OyAvKiBwYXNzd29yZCBpcyBudWxsIGJ5dGUgKi8KLQkJYmNjX3B0cisrOyAgICAgICAgICAgICAg
Lyogc2tpcCBwYXNzd29yZCAqLwotCQkvKiBhbHJlYWR5IGFsaWduZWQgc28gbm8gbmVlZCB0byBk
byBpdCBiZWxvdyAqLwotCX0KKworCXBTTUItPlBhc3N3b3JkTGVuZ3RoID0gY3B1X3RvX2xlMTYo
MSk7CS8qIG1pbmltdW0gKi8KKwkqYmNjX3B0ciA9IDA7IC8qIHBhc3N3b3JkIGlzIG51bGwgYnl0
ZSAqLworCWJjY19wdHIrKzsgICAgICAgICAgICAgIC8qIHNraXAgcGFzc3dvcmQgKi8KKwkvKiBh
bHJlYWR5IGFsaWduZWQgc28gbm8gbmVlZCB0byBkbyBpdCBiZWxvdyAqLwogCiAJaWYgKHNlcy0+
c2VydmVyLT5zaWduKQogCQlzbWJfYnVmZmVyLT5GbGFnczIgfD0gU01CRkxHMl9TRUNVUklUWV9T
SUdOQVRVUkU7Ci0tIAoyLjM0LjEKCg==
--0000000000000f2e0e05ecea29e8--
