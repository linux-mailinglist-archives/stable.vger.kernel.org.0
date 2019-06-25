Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A923F553B2
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 17:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbfFYPqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 11:46:08 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:44487 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfFYPqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 11:46:08 -0400
Received: by mail-lf1-f65.google.com with SMTP id r15so12950443lfm.11;
        Tue, 25 Jun 2019 08:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5HkYvt7vqYcoplSqjUO7R3ulPIH/lqglCxToVLLxHq0=;
        b=qXtq11GckrDcJCHDDEgthhpG8mHYmTpXpzctewOXeUwZmzUo0b5ZeAtMwVAfPHhIPT
         3RhfwsBrNQETw2uzvpCbSc8dG/ITMshgLL9OzsWB5XOnH1VuBhB1eJF709b3TLytZa66
         iPZ6oUBRjQ47hp3xXYtwKt8NpfCcGF3sPAHVG6KRSOSsrYYx/5qUxulw8KdpvUSSNZ6j
         wxuwby4vZz9pG3VaHAkPbhhkzSoLLFtCq/7AA0gftSopUeZpN5J3cYWU7xqUlQBj2TsE
         sWo6eQY/SLn3t/XWBGW9SmsuLqBCzeFuVIqOzL9A+qq68NVNOowGczMSJrmpmUYAm2p8
         RLHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5HkYvt7vqYcoplSqjUO7R3ulPIH/lqglCxToVLLxHq0=;
        b=RImzWAmk85hJDcS1JoVRUHJZsED/dm/ANwRrs0ZmC3wQwRNkrX5kzi+3zNSW+Ym3fY
         2TabmsQABekY508UA6/WlZACtnDjHsVfgnYlyh7JlPI+kQAdqlfM2aCcPACQfUM4NCO3
         lPBWYfIjaRZbrBEzPePaddb+n1JpZKuwhxTJ8uGy0N5kWY4Nj1krJcwTcyEQZbWqxlqL
         6gm8sXToCbozozXxsUuNDrcBxt2+IytEF6Uepm5HoDURNqhmy973Dx2+heZ8MeQvzB4N
         QDfE/DVUjiP3w2b+lSEZBb/1BFmutYJDFt3RfsoVnTMlsQhv9injIw25YmUvbno9sb0y
         t+Ew==
X-Gm-Message-State: APjAAAUvHn6RMLmycI9CtS0Y+fw8se2C4p1BFcyj/0CY2lTpAJ9++X+A
        qPx+7ArbDpYx6lz/lMfImfP7hIYHc0LD3WOJ4UA=
X-Google-Smtp-Source: APXvYqzVkv3ISEpy81fk9GqWVELv6LncGBQA618cty6rXyn6Ym+TyTksnqIcZ4ZJkwyOgbRhI2GPWbZy/JzI4c4/Nq0=
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr16968201lfn.12.1561477566289;
 Tue, 25 Jun 2019 08:46:06 -0700 (PDT)
MIME-Version: 1.0
References: <20190621082306.34415-1-yibin.gong@nxp.com> <CAOMZO5B+uXF=1WTPsA-9LrmtTF0Q0s7Fipwtd1nkWSgr3ec25w@mail.gmail.com>
 <VE1PR04MB6638D58DED0D7092D8FCE93589E30@VE1PR04MB6638.eurprd04.prod.outlook.com>
In-Reply-To: <VE1PR04MB6638D58DED0D7092D8FCE93589E30@VE1PR04MB6638.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 25 Jun 2019 12:45:54 -0300
Message-ID: <CAOMZO5AUnDJ_Wz3sWFDv4hZ-vAwO4_ioTW=5FUNDwFS7zBRJOg@mail.gmail.com>
Subject: Re: [PATCH v2] dmaengine: imx-sdma: remove BD_INTR for channel0
To:     Robin Gong <yibin.gong@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Vinod <vkoul@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Sven Van Asbroeck <thesven73@gmail.com>,
        Michael Olbrich <m.olbrich@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        stable <stable@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Robin,

On Tue, Jun 25, 2019 at 4:36 AM Robin Gong <yibin.gong@nxp.com> wrote:

> Yes, although Sven only met this issue after v4.19, this potential issue should be there.
> But 1d069bfa3c78 seems merged from v4.7 instead?

Yes, you could simply do:

Fixes: 1d069bfa3c78 ("dmaengine: imx-sdma: ack channel 0 IRQ in the
interrupt handler")
Cc: stable@vger.kernel.org

And it will get applied to all relevant stable trees.

Thanks
