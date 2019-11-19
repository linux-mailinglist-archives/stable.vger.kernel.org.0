Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEED10253C
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726369AbfKSNRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:17:20 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:45038 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725280AbfKSNRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 08:17:19 -0500
Received: by mail-lf1-f68.google.com with SMTP id n186so4574640lfd.11
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 05:17:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0EqUQo3NasiGqgLvltuGxf5G3adkoYdVBTkwSDettt4=;
        b=BB+605LR+SJuP3Wh/g4yBxlHuJA/bF/7xp5ZS3aZsNq14QY3+JMR5uIqD38bv1WLYT
         HzKUe4V+7QZ4KWcn7y/NxntZ352ZMUYO7QDNCT4lycToQ3Nhok3Bd10fhVWv2yT2oFBj
         EsjwmEr1ZsmvMt8F0hEsaB1Hx6xcx0g8KZmp4jdQah4GUqZQW4JFudZTbh1XiNMcsbr2
         xYuCftq1i0cIR8JHY4y/CiAGAO6KeIXfHsPMtZ4GcqhtHgu4vCc6smu2lBXjFa0laOYF
         cyzN865pPi1P6c6K2DvyMSGTshgaRhyXoFcFWAMPe8a8ai+3jOKYCF+3rIf8pEyGjbCZ
         7SiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0EqUQo3NasiGqgLvltuGxf5G3adkoYdVBTkwSDettt4=;
        b=iSMyFCzs2Uoc+gmp+2UJaSdW1NlIJyUoOcN8t6u3hYh4qxiU5yCE8e2wz7f06lIRLK
         KOw8Nb80Q+HB6as7jZkfsTo3ouVF5IhJDcNtFJ3o37eg0qe+tx3BIMHzXhnK3ppHf2Im
         UvcrN4ZNbtAqP8tPetnSV4h8ixN+xh/e+aJo1HKylpBgsXvXVsKwrjMrBJ4tXxSy0Uq/
         z7ywqwzwAJuaZ73seiyd8bMwbOOx9bZWW+/7aX/4QK3jhIfeBOA42EsRzKlDRuBha0Ox
         VWCJxHqNnOJrKWBA5UR2InzFQSRizn8Gl1R2MC60G8x3RXI6ld1Ikr+K+8W8Y2Qkzwiq
         KExA==
X-Gm-Message-State: APjAAAXN3IEGybAW90yqUcrFFfNFFGNadNFUy04upJLUnodsdoQe10GA
        KR+C8PlUgdWCP+K9plS7eTNbyDnJUdLnh0iJx08JRA==
X-Google-Smtp-Source: APXvYqxOUtZYiMfI58Cm5sdIrZwlm+YLCMSb8LYdQOet1pUdnIYiQxAXrpexBZFq2fCwdjGXDGnowFw0G68siYIio6Q=
X-Received: by 2002:a19:e018:: with SMTP id x24mr3753217lfg.191.1574169437118;
 Tue, 19 Nov 2019 05:17:17 -0800 (PST)
MIME-Version: 1.0
References: <20191119050946.745015350@linuxfoundation.org> <0ca5da93-b597-acb7-169c-a75421ecbd34@applied-asynchrony.com>
 <20191119124518.GD1975017@kroah.com> <e29c219f-74bb-a66a-fd70-7121459a8354@applied-asynchrony.com>
In-Reply-To: <e29c219f-74bb-a66a-fd70-7121459a8354@applied-asynchrony.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Tue, 19 Nov 2019 18:47:05 +0530
Message-ID: <CA+G9fYsWZxewjZoW53NCMo_2soBsXKtWJGBhLB0FrwC2x1nh7A@mail.gmail.com>
Subject: Re: [PATCH 5.3 00/48] 5.3.12-stable review
To:     =?UTF-8?Q?Holger_Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux- stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 19 Nov 2019 at 18:35, Holger Hoffst=C3=A4tte
<holger@applied-asynchrony.com> wrote:
>
> On 11/19/19 1:45 PM, Greg Kroah-Hartman wrote:
> > On Tue, Nov 19, 2019 at 01:35:26PM +0100, Holger Hoffst=C3=A4tte wrote:
> >> Hi Greg,
> >>
> >> On 11/19/19 6:19 AM, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 5.3.12 release.
> >>> There are 48 patches in this series, all will be posted as a response
> >>> to this one.  If anyone has any issues with these being applied, plea=
se
> >>> let me know.
> >>>
> >>> Responses should be made by Thu, 21 Nov 2019 05:02:35 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.3.12-rc1.gz
> >>
> >> That patch has not shown up after 7 hours - is the mirroring stuck?
> >
> > No idea.  What mirror are you using?

Wget failed with below link and web page showing "Sorry, we cannot
find your kernels"
with pop corn image :-)

wget https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.1=
2-rc1.gz
--2019-11-19 18:45:44--
https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.3.12-rc1=
.gz
Resolving www.kernel.org (www.kernel.org)... 147.75.46.191,
2604:1380:4080:c00::1
Connecting to www.kernel.org (www.kernel.org)|147.75.46.191|:443... connect=
ed.
HTTP request sent, awaiting response... 301 Moved Permanently
Location: https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-revi=
ew/patch-5.3.12-rc1.gz
[following]
--2019-11-19 18:45:46--
https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5=
.3.12-rc1.gz
Resolving mirrors.edge.kernel.org (mirrors.edge.kernel.org)...
147.75.95.133, 2604:1380:3000:1500::1
Connecting to mirrors.edge.kernel.org
(mirrors.edge.kernel.org)|147.75.95.133|:443... connected.
HTTP request sent, awaiting response... 404 Not Found
2019-11-19 18:45:48 ERROR 404: Not Found.


wget https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-review/pa=
tch-5.3.12-rc1.gz
--2019-11-19 18:44:38--
https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5=
.3.12-rc1.gz
Resolving mirrors.edge.kernel.org (mirrors.edge.kernel.org)...
147.75.95.133, 2604:1380:3000:1500::1
Connecting to mirrors.edge.kernel.org
(mirrors.edge.kernel.org)|147.75.95.133|:443... connected.
HTTP request sent, awaiting response... 404 Not Found
2019-11-19 18:44:40 ERROR 404: Not Found.

- Naresh
