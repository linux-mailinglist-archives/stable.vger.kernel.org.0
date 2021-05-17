Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1080838225F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 02:42:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbhEQAnx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 May 2021 20:43:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhEQAnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 May 2021 20:43:53 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF07C061573
        for <stable@vger.kernel.org>; Sun, 16 May 2021 17:42:36 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id z1so4674643ils.0
        for <stable@vger.kernel.org>; Sun, 16 May 2021 17:42:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zUT0jGhblhx8FFFXO9g3iUrg2t8VnLs9CTg0TU8APOU=;
        b=sGAlykYY8YMe4SVZVe/QDujeEkDywOWO62RK3wzSLwD1Mj1tO1FUv6fk+aBtRG2gbh
         /7lUuen7U2K68BKJolLNZp9ASBYhII5CIK2ZeERsMg96779cNiI0af9nRh/B4e8YOHiv
         3VrCqiS22r6SGwZ2NathCIQ75a90tbil8ZHeVuU8WLX3xbDVKOLs+gN4lprZeYZ00PZY
         jULOyHdnwgsRdwIUw9sRdYzgqO7SjXos4BhtPP+6BhEvmFgMyVCfMT5CJPLz+TcOVmie
         Vcbzp6PlUtK8oW7IugMhIZFqnwozx/nxITF36OlIOZYoWlG7qbklXB3J263JNm5a6LrX
         0s1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=zUT0jGhblhx8FFFXO9g3iUrg2t8VnLs9CTg0TU8APOU=;
        b=MG9YqH3GUf82XnnktWgcGjPPjYLxcw6vDEtqbuNnqFdQ+d9t//CM68HMHOmfPj3fbH
         IIrGhe1Eq/ZLACU8GhkvzO5X1U8y2JQgpqD5InmfQGY1lILm15Y7JDg5VBe5vDOKCuOx
         /19t+fp9bq3kgA/xcft/EF22BbzoFNtBGakxBgBOcFLq3ma22UWw2Zi9hWLb04v4uMN6
         EHGhriDNgw69B6QozhiT7zuAUPzBALx4jQMdN4JOoSxy7yiun8M4E/vZvGeyB0BPtB/H
         djYNRi5ls2dWuiMkqKr8ceWut99yu+++EWAwj3wUcWRfrjdxoKfRDNXNoG/K/c4cmKwa
         Dcyg==
X-Gm-Message-State: AOAM530jW66jh62xzlGJHrk2vuXjt1Pdju+UrBzTjldaPF+rPuS0j97b
        +WCUKmTOrceQs7k+6jywRsfE/y24rUu58fiqoag=
X-Google-Smtp-Source: ABdhPJyOxkPdEKRMkp7Ahs7Jfnq1zgKBjkA7kIQiR8Z7a9MKgxx7JfOE89Xj4Eb3tomGR+g7Vru4V9eBc+1Mu5jUM24=
X-Received: by 2002:a92:cccb:: with SMTP id u11mr46457518ilq.36.1621212156086;
 Sun, 16 May 2021 17:42:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: zinahamza139@gmail.com
Sender: criosbankgroup.ln@gmail.com
Received: by 2002:a05:6638:10c:0:0:0:0 with HTTP; Sun, 16 May 2021 17:42:35
 -0700 (PDT)
From:   Zina Hamza <zinahamza139@gmail.com>
Date:   Mon, 17 May 2021 00:42:35 +0000
X-Google-Sender-Auth: KCYE8RJzGDwXTgt5rqbwfg-t-Sg
Message-ID: <CAPHHahMLkg7jv6DpTNxmb4jBPMUg=fCSoEqJ5bgfo57zvSX+ow@mail.gmail.com>
Subject: Hello,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGVsbG8sDQoNCkhvdyBhcmUgeW91IHRvZGF5PyBJIGZlZWwgbGlrZSBjb21tdW5pY2F0aW5nIHdp
dGggeW91LCBteSBuYW1lIGlzIFppbmENCnNpbmdsZSBtYXJpdGFsIHN0YXR1cywgaSBhbSAyNSB5
ZWFycyBvbGQuIEkgd2lsbCBzZW5kIG15IHBob3RvIGF0DQpsZWFzdCBmb3IgeW91IHRvIHNlZSB3
aG8gaXMgd3JpdGluZyB0byB5b3UuIEkgd2lsbCBnaXZlIHlvdSBhIGZ1bGwNCmV4cGxhbmF0aW9u
IGFib3V0IG15c2VsZiwgbXkgcmVhc29ucyBhbmQgcHVycG9zZXMgdG8gY29udGFjdCB5b3UuDQoN
CkZlZWwgZnJlZSB0byB3cml0ZSBiYWNrIHRvIG1lLCBwbGVhc2UuDQoNClNpbmNlcmVseSwNCg0K
WmluYQ0KLS0tLS0tLS0tLS0NCuS9oOWlve+8jA0KDQrkvaDku4rlpKnmgI7kuYjmoLfvvJ8g5oiR
5oOz5ZKM5L2g5Lqk5rWB77yM5oiR55qE5ZCN5a2X5Y+rWmluYeWNlei6q+WpmuWnu++8jOaIkeS7
iuW5tDI15bKB44CCIOaIkeWwhuiHs+WwkeWwhueFp+eJh+WPkemAgee7meaCqO+8jOS7peS6huin
o+iwgeWcqOe7meaCqOWGmeS/oeOAgg0K5oiR5bCG5Li65oKo5o+Q5L6b5pyJ5YWz5oiR6Ieq5bex
77yM5oiR5LiO5oKo6IGU57O755qE55CG55Sx5ZKM55uu55qE55qE5a6M5pW06K+05piO44CCDQoN
Cuivt+maj+aXtue7meaIkeWbnuS/oeOAgg0KDQrnnJ/mjJrlnLDvvIwNCg0K6b2Q5aicDQo=
