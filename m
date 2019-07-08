Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1AAF61E64
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 14:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfGHM1n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 08:27:43 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:35635 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGHM1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Jul 2019 08:27:43 -0400
Received: by mail-io1-f65.google.com with SMTP id m24so25268442ioo.2
        for <stable@vger.kernel.org>; Mon, 08 Jul 2019 05:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=yJ/ZC1foM+OeX5oj0w8tEazMB5pZha6Ec/92YrOC/Jo=;
        b=u88Up9wTTRqd5cXk3ZrwxFtBxmv7GFLTmXC3HmxJQTgzW4JKfJJVEJBLazbIcjz5LN
         SFS4nz5Ff6sxI7rtGdkHPYnnvf/CuBqF9DMQC5PJO1jxxxma6nCvdN+Y4euapXk8DsXI
         umGUihAUogu2wVBVnCKkn/Jhz0UuMJhPRnycPHduqdRaQ6D4qFebVBs+6d4n7WUfxGl8
         MogR9bgnFSU2r8mHu9ZMHR1g1KDWz3uiaShMfMx8o0WBG2IAtDYNYaCaU69wSb6vHwPv
         PwdVBDXTgqXHvz1h/frr0KvTF1SWfSlkS2PxAeQBli3RBb8A93CgPiBGaB7rhx//i00I
         8DSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=yJ/ZC1foM+OeX5oj0w8tEazMB5pZha6Ec/92YrOC/Jo=;
        b=CrPFcUA8ugLQNx6VOjbuAxFYrwIAkZPRCN8CIEk++1Mu5/DyjrE2hGFXKUb712dAMF
         fXNGlm2blnVxwkKYuIAK55cxR01oIjECBuUuOXGHVjq+O8Hg3gEEbmzWysbj/QHC6IlP
         f7bKGPl45jHvfHtt11WyhRWanZcyAwYZfv8X7Q/qrsTJmslVJNh1m1fRjD6K7DuZSTmp
         +9ZO5vJUp9yiF9lC9Jq49HBal/y2MyGywWIYxDVMWAKBG9Tg6PVlGynVsP0rofgiAXER
         2SeDU6zsTf7dBvB301baJve82elA2tjM4feUM+teM9jBIPcPua4JqanDIzXpeBnhPCRW
         4IWQ==
X-Gm-Message-State: APjAAAXTX4f8MLLsq2m8DtxMGlkAIX8oK6mr5DIH25h78igQb+XPWAT+
        5QD9s7eYCcgHcZzGafXwP8hqCZrifiAIywxYu7E=
X-Google-Smtp-Source: APXvYqw23o/9q/1Aja7W6QJuqGEnLDmg61RodiVPBESzLUVqfCONqs2+eNceS2PKZSnzVLVX7od3/SdLqGdBuqSpvJM=
X-Received: by 2002:a6b:6611:: with SMTP id a17mr1478016ioc.179.1562588862238;
 Mon, 08 Jul 2019 05:27:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:909c:0:0:0:0:0 with HTTP; Mon, 8 Jul 2019 05:27:41 -0700 (PDT)
Reply-To: katiehiggins701@gmail.com
From:   katie Higgins <lucielawfirm@gmail.com>
Date:   Mon, 8 Jul 2019 13:27:41 +0100
Message-ID: <CAJ4Pj78=f+4FzeD2Erghp8k_tX8kHHdBu2cf1053yRPXpijdBA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

TGllYmUgR3LDvMOfZQ0KSGFsbG8sIGljaCBiaW4gTGFkeSBLYXRpZS4gRGllcyBpc3QgZGFzIHp3
ZWl0ZSBNYWwsIGRhc3MgZGllc2UgRS1NYWlsDQp2ZXJzZW5kZXQgd2lyZCBJaG5lbiB6dWdlc2Fu
ZHQgdW5kIGRvY2ggaGFiZW4gU2llIG1laW5lIEUtTWFpbC1BbnR3b3J0DQphYmdlbGVobnQsIHdh
cnVtLCB3YXMgaXN0IGRhcyBQcm9ibGVtPyBJY2ggd2VyZGUgc2VociBnbMO8Y2tsaWNoIHVuZA0K
ZGFua2JhciBzZWluLCB3ZW5uIFNpZSBhdWYgbWVpbmUgTmFjaHJpY2h0IGFudHdvcnRlbiBrw7Zu
bmVuLiBJY2ggbXVzcw0KSWhuZW4gZXR3YXMgc2VociBXaWNodGlnZXMgbWl0dGVpbGVuLCBlaW5z
Y2hsaWXDn2xpY2ggbWVpbmVzDQp3dW5kZXJzY2jDtm5lbiBzZXh5IEJpbGRlcywgdW5kIGljaCB3
ZWnDnywgZGFzcyBTaWUgc2llIGxpZWJlbiB3ZXJkZW4NCldhcnRlIGF1ZiBkZWluZSBBbnR3b3J0
DQoNCkt1c3MNCj09PT09PT09PT09PT09PT09PT09PT09DQrYqtit2YrYp9iq2Yog2KfZhNi52LLZ
itiy2KkNCtmF2LHYrdio2YvYpyDYo9mG2Kcg2LPZitiv2Kkg2YPYp9iq2Yog2Iwg2YfYsNmHINmH
2Yog2KfZhNmF2LHYqSDYp9mE2KvYp9mG2YrYqSDYp9mE2KrZiiDZitiq2YUg2YHZitmH2Kcg2KXY
sdiz2KfZhCDZh9iw2KcNCtin2YTYqNix2YrYryDYp9mE2KXZhNmD2KrYsdmI2YbZig0K2KPYsdiz
2YTYqiDZhNmDINmI2LHZgdi22Kog2KfZhNil2KzYp9io2Kkg2LnZhNmJINio2LHZitiv2Yog2KfZ
hNil2YTZg9iq2LHZiNmG2Yog2Iwg2YTZhdin2LDYp9ifINiz2KPZg9mI2YYg2KzYr9inDQrYs9i5
2YrYryDZiNmF2YXYqtmGINil2LDYpyDYp9iz2KrYt9i52Kog2KfZhNil2KzYp9io2Kkg2LnZhNmJ
INix2LPYp9mE2KrZiiDYjCDZhNiv2Yog2LTZitihDQrZhdmGINin2YTZhdmH2YUg2KzYr9inINij
2YYg2KPYtNin2LfYsdmD2YUg2KjZhdinINmB2Yog2LDZhNmDINi12YjYsdiq2Yog2KfZhNis2YXZ
itmE2Kkg2KfZhNis2YXZitmE2KkNCtmI2KPZhtinINij2LnZhNmFINij2YbZgyDYs9mI2YEg2KrY
rdio2YfZhQ0KDQrYp9mG2KrYuNixINis2YjYp9io2YMNCg0K2YLYqNmE2KkNCg==
