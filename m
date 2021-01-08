Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44F52EF0EA
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 11:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbhAHKzB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 05:55:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbhAHKzA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 05:55:00 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C93C0612F5
        for <stable@vger.kernel.org>; Fri,  8 Jan 2021 02:54:20 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id s26so21881383lfc.8
        for <stable@vger.kernel.org>; Fri, 08 Jan 2021 02:54:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=ik6B+6lkNc+iFrIPLOlH6nyfA0JsJ4cRGzVhof+Ll8w=;
        b=V0ZvdrGC3VMKp0SLZyHdtKlyh2IaktqkNFnUxX22Vr1R+qil3McJGnUHvDjoXP9Z4u
         E0EbNSIBcPGprVJS3CF7s2yzcdY9I8JXsDxRRmd+9JLYYcIXUSqHpDCY8EembWya1LQb
         LiGVMWCx+FnLPaS5nBv/ZIwYkEDTBsW1k/J6r6kWjJRPrCO7AlH3n8JJIZTZDPj5V4nf
         TgOnSv03gwjBHc6a9GM+VOJcf9/8VyWJJzk8rXihmqvSlOd40Orei8rc9uM/Yph6JwIN
         X8B5CNS/ipmtlfN8VCtT6k7rInMf9Q+eKT/6diZ1oAPvD3zRviboXmm6DLMw6RJFGAWZ
         kv3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:in-reply-to:references:from
         :date:message-id:subject:to:content-transfer-encoding;
        bh=ik6B+6lkNc+iFrIPLOlH6nyfA0JsJ4cRGzVhof+Ll8w=;
        b=hbxKf+WUcO184Z/xsLy6tpU6RqaAX50YWeJCcBldW7MHLNHrt2QRShj0LCFrkNxx/4
         cquQaYcuYPIaIfPNSA9sSgWAxuwCOmYNsj39ksuL5mAPfIa1PuSOQCSTMN3Yj8cbBjzo
         oUrIW3jJpuiJlfArNzyyARClVjSIc0l4ViHHhPQMC2WjKw/oqYmtU6PY4WditKWR4SAF
         0z44jXLCBAKTwHUmv7RjdvU/0wc7kncFQHwvKHH1CEkdTPK7+98Nqs1c6XBLYWghd7s4
         ssXVC7e2CLNvphI5rcg1stT9dXk03ZGic0YS7Wp62TQW270NZNLRIVLeGYkZSKhZP3Yd
         MCFw==
X-Gm-Message-State: AOAM533g+Y3sfjPd0IoVCEvgFLIoXN+X/ViWJpskFIE947cW/vWWfTwc
        61q79MD99jaoKB6MnDCU7iFdmrA9H311ic6CHA==
X-Google-Smtp-Source: ABdhPJyQxn2DX6NoAxSUJwjx/5zNpbvVA67bOul9Rj093Zdg50ZKuUVoHs83jrfc4I8VSohCug5J9ia+s8CSkMo/DJI=
X-Received: by 2002:a19:ad0a:: with SMTP id t10mr1498314lfc.471.1610103258821;
 Fri, 08 Jan 2021 02:54:18 -0800 (PST)
MIME-Version: 1.0
Sender: kossibrewena@gmail.com
Received: by 2002:ab3:680e:0:0:0:0:0 with HTTP; Fri, 8 Jan 2021 02:54:18 -0800 (PST)
In-Reply-To: <CALKsWkgg0AquqOk4RcCsrUm-LjsRFV00m76ds94HDPOV8UZuwA@mail.gmail.com>
References: <CALKsWkgg0AquqOk4RcCsrUm-LjsRFV00m76ds94HDPOV8UZuwA@mail.gmail.com>
From:   camille <camillejackson021@gmail.com>
Date:   Fri, 8 Jan 2021 10:54:18 +0000
X-Google-Sender-Auth: yNgSnTmoiWdPsTWYfNIlnP8iV3o
Message-ID: <CALKsWkj-P9Ayeztzrssj2Q1K+gbMdbcQ22dED+mrhmx=7PZ=MA@mail.gmail.com>
Subject: =?UTF-8?B?0JfQtNGA0LDQstGB0YLQstGD0LnRgtC1LA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

0J/RgNC40LLQtdGC0YHRgtCy0YPRjiDRgtC10LHRjywg0LzQvtC5INC00YDRg9CzLCDQvdCw0LTQ
tdGO0YHRjCwg0YLRiyDQsiDQv9C+0YDRj9C00LrQtSwg0L/QvtC20LDQu9GD0LnRgdGC0LAsINC+
0YLQstC10YLRjCDQvNC90LUNCtCx0LvQsNCz0L7QtNCw0YDRjywNCg==
