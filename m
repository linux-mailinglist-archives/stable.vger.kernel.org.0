Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F367CDCA08
	for <lists+stable@lfdr.de>; Fri, 18 Oct 2019 17:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390780AbfJRP6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 11:58:19 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37585 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfJRP6S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Oct 2019 11:58:18 -0400
Received: by mail-lf1-f67.google.com with SMTP id g21so3998705lfh.4;
        Fri, 18 Oct 2019 08:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ttfvaz7iNEFfCRYhhy3E48U+pPKKC4mHvgM6ZOuohSI=;
        b=dJP58M9vHzMkCf5/o1RrXt+Ia+M2sk7thkCGT5jKU/ktMPYcBavPvfLMXyywixcrPv
         r/6s8/18Z5CoAeKMdO1OZLaBmrvILDFBHpzwJQ85zpmRT+Boxn6ZPEI93y8MKTJjJheE
         W/rb1fK1YoVS1YUL2Px4AlGUGSG+ZZ6RGXUPz70KSkMa5IAZKxe9NBUdqqdchiV7KhkK
         1Xvqh3SyPfi8eOVUbWT9sYXsxtuKDF1ICO9aybHMBEE+5QSavljNbwXrD5nAD0CTcJYw
         X+6TG+pJyLtrs0S7Me+HHqOxC+BgZjzyjqms3chepSWMUTa1GAuI7MkDajSZw7SSFcgs
         GrOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ttfvaz7iNEFfCRYhhy3E48U+pPKKC4mHvgM6ZOuohSI=;
        b=Z+Nb0CrSXOowkvCHmYM6IG9uVdVBBe3OoDHT0dVF9zhOxgELYTLoGWMe7F4U0W9gTw
         yfJ7MRAkh7Nwld8YiiF1B1Q+SuQzpKPSeAXwxiRep+TUwheBwT8eE+dgairYfDOEf6og
         5cLS8ssVRr/k1Hl/oh2DqQ65lHBBrd0FY2Q1mFOPtIdTIybVjY6TIgYw7Els4s8Q8Fbz
         12aq7UWmi4g/FULZjQKhsoVXTsN7i9ET1NF1g4uPvkHeYNG0A1R5wWxx+eN/2q1cGwr4
         1wsJYJUu2tOtuh/xmEFJTf6rOW4gDNvnPXy9d2WVlW3gDYBzHlm3u44eqxDRDe4EgW3D
         HPKQ==
X-Gm-Message-State: APjAAAX0O2AXpPkChE4Ecw+Ro+n4RzqruSWY0TRlESOXJUJkhj/+6/ir
        XcbtVSOPFCSAcso4+KlX2Crc+a2bGEjOq6Tfn/U=
X-Google-Smtp-Source: APXvYqxP8/0QV8rT3k2NWSOm1ssIagw4Xb5opwj1fUKOPiN7qQ+KYU0iCPMlNK9Oe5i3uj2Oyc/w2A1YY5CYIyNcmAM=
X-Received: by 2002:ac2:4a68:: with SMTP id q8mr6761021lfp.20.1571414296651;
 Fri, 18 Oct 2019 08:58:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191018093934.29695-1-s.hauer@pengutronix.de>
 <CAOMZO5DUoj4xVZQSvk9Juw9z37UgrMn3g24h2_pAMxuTkBjw4g@mail.gmail.com> <20191018133435.oncn7nktihpqyj4z@pengutronix.de>
In-Reply-To: <20191018133435.oncn7nktihpqyj4z@pengutronix.de>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 18 Oct 2019 12:58:07 -0300
Message-ID: <CAOMZO5DLebwVYJGfT=n+j3T62Ps8eJAZWKCb55Xck=thimubrA@mail.gmail.com>
Subject: Re: [PATCH] mmc: mxs: fix flags passed to dmaengine_prep_slave_sg
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-mmc <linux-mmc@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Bruno Thomsen <bruno.thomsen@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 18, 2019 at 10:34 AM Sascha Hauer <s.hauer@pengutronix.de> wrote:

> We would probably also have to revert the exec_op conversion of the gpmi
> NAND driver, something which I'd rather not do.

Ok, understood. Thanks for the clarification.

Better go with your patch then.

Thanks
