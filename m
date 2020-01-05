Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4061308CF
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbgAEPgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jan 2020 10:36:03 -0500
Received: from wnew2-smtp.messagingengine.com ([64.147.123.27]:35147 "EHLO
        wnew2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726212AbgAEPgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jan 2020 10:36:03 -0500
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jan 2020 10:36:02 EST
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 63D3C5FF;
        Sun,  5 Jan 2020 10:27:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 05 Jan 2020 10:27:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sholland.org; h=
        subject:to:cc:references:from:message-id:date:mime-version
        :in-reply-to:content-type:content-transfer-encoding; s=fm1; bh=s
        rCX085Fcg6QJTzWvKbgSzWWkOVQY8YF3nspHYJ3mXw=; b=Qxq6/1zuezyfGDttK
        nc1Vq/vhSPg4CkwsygWouH1ePqasr9TRJK6trM7L4myM5U9V5cTWiq4C+li1C6Qw
        wY+/6AShZLzd+fgZWyTXWVrBG3TGFCsi2eNoIJAqVOV14Dni982Xfo3hM3PA2p5l
        zFgg+/Hh+D49f1OtPT/Ng1eNNmnvuLgjNg9nqhxWKao/YxKlFWT/CqWxxkVus2u9
        g+DkJTC2Zsq4mR3EIpwhvg+xHaWE7afbbOfT9BqBzfo80a6hfye/Q8czX+qw8TjB
        +Z4kY/mramtceQE9TJ9z57s4/vHsjIZzaUjETvF2ZLjQY1S4yi0/gsMO1P/au2Y4
        RKedQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=srCX085Fcg6QJTzWvKbgSzWWkOVQY8YF3nspHYJ3m
        Xw=; b=hDIr/GEvNuapESIHqigtM6hwqUp2RUbAxrYzhTjDnsOpPwpugMyvaXQKi
        y+/o6YHMq13fiQhzj3SXatTz5/OqSeXy8F6cicajp+idf4eTgv2GyBGiiHbCavVT
        jSZ9LHWFSfVPMuspnEfIZWNO4m8zLCSIOwOXHu7isyMQi5QG6bz4/gF/6bkmW3K2
        X85QbmCh7+NVTfTZnwmpROE1rVg+ZGjIYjekaY1y0CQHpTx46hkUQk0N6YP8Bvop
        x6YoHvtFAQTYrwXQQvHbuQprUpZuk4ZuRXK+v68pwVG3VH27EuyU5L3k0bZG6mj5
        Wvuhiufl9mKn2yyrILk4aI38kVb+Q==
X-ME-Sender: <xms:TgASXmFgVFdIyq29-ziqQ8h2HizIwQbZYGSjm8s9QZsmnT2t9JzVRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdegkedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepuffvfhfhkffffgggjggtgfesthejredttdefjeenucfhrhhomhepufgrmhhu
    vghlucfjohhllhgrnhguuceoshgrmhhuvghlsehshhholhhlrghnugdrohhrgheqnecukf
    hppeejtddrudefhedrudegkedrudehudenucfrrghrrghmpehmrghilhhfrhhomhepshgr
    mhhuvghlsehshhholhhlrghnugdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:TgASXu7-gUu1DRRRgVIFZLrTjbFm0eN-GQPT0Ijo2WzKpI2Qdcr0Ig>
    <xmx:TgASXvxpdnMllh4roMW0NVo2UlX8JP2FJsoGfaYyor9_bnFl--BRNg>
    <xmx:TgASXs3npnzidKxoiEPlPzgR8irJH567GW5peUBTQydu75wyRCq__Q>
    <xmx:TwASXlC_kvP64e2oXAp_bZyfIGHaKGmXmuU_O2WL6tOSMssT-58Eq9E-zFs>
Received: from [192.168.50.169] (70-135-148-151.lightspeed.stlsmo.sbcglobal.net [70.135.148.151])
        by mail.messagingengine.com (Postfix) with ESMTPA id CE31B30602DB;
        Sun,  5 Jan 2020 10:27:09 -0500 (EST)
Subject: Re: [linux-sunxi] [PATCH v2 2/9] power: supply: axp20x_ac_power: Fix
 reporting online status
To:     Julian Calaby <julian.calaby@gmail.com>
Cc:     Chen-Yu Tsai <wens@csie.org>, Sebastian Reichel <sre@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Oskari Lemmela <oskari@lemmela.net>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-sunxi <linux-sunxi@googlegroups.com>,
        stable@vger.kernel.org
References: <20200105012416.23296-1-samuel@sholland.org>
 <20200105012416.23296-3-samuel@sholland.org>
 <CAGRGNgXeenNYMNXY0dewQaeG2QecUPgE_MOofURg7HzcND782w@mail.gmail.com>
From:   Samuel Holland <samuel@sholland.org>
Message-ID: <6e299dd3-3d70-9306-8581-798927241779@sholland.org>
Date:   Sun, 5 Jan 2020 09:27:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <CAGRGNgXeenNYMNXY0dewQaeG2QecUPgE_MOofURg7HzcND782w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Julian,

On 1/5/20 7:00 AM, Julian Calaby wrote:
> On Sun, Jan 5, 2020 at 12:24 PM Samuel Holland <samuel@sholland.org> wrote:
>>
>> AXP803/AXP813 have a flag that enables/disables the AC power supply
>> input. This flag does not affect the status bits in PWR_INPUT_STATUS.
>> Its effect can be verified by checking the battery charge/discharge
>> state (bit 2 of PWR_INPUT_STATUS), or by examining the current draw on
>> the AC input.
>>
>> Take this flag into account when getting the ONLINE property of the AC
>> input, on PMICs where this flag is present.
>>
>> Fixes: 7693b5643fd2 ("power: supply: add AC power supply driver for AXP813")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Samuel Holland <samuel@sholland.org>
>> ---
>>  drivers/power/supply/axp20x_ac_power.c | 31 +++++++++++++++++++++-----
>>  1 file changed, 25 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/power/supply/axp20x_ac_power.c b/drivers/power/supply/axp20x_ac_power.c
>> index 0d34a932b6d5..ca0a28f72a27 100644
>> --- a/drivers/power/supply/axp20x_ac_power.c
>> +++ b/drivers/power/supply/axp20x_ac_power.c
>> @@ -23,6 +23,8 @@
>>  #define AXP20X_PWR_STATUS_ACIN_PRESENT BIT(7)
>>  #define AXP20X_PWR_STATUS_ACIN_AVAIL   BIT(6)
>>
>> +#define AXP813_ACIN_PATH_SEL           BIT(7)
>> +
>>  #define AXP813_VHOLD_MASK              GENMASK(5, 3)
>>  #define AXP813_VHOLD_UV_TO_BIT(x)      ((((x) / 100000) - 40) << 3)
>>  #define AXP813_VHOLD_REG_TO_UV(x)      \
>> @@ -40,6 +42,7 @@ struct axp20x_ac_power {
>>         struct power_supply *supply;
>>         struct iio_channel *acin_v;
>>         struct iio_channel *acin_i;
>> +       bool has_acin_path_sel;
>>  };
>>
>>  static irqreturn_t axp20x_ac_power_irq(int irq, void *devid)
>> @@ -86,6 +89,17 @@ static int axp20x_ac_power_get_property(struct power_supply *psy,
>>                         return ret;
>>
>>                 val->intval = !!(reg & AXP20X_PWR_STATUS_ACIN_AVAIL);
>> +
>> +               /* ACIN_PATH_SEL disables ACIN even if ACIN_AVAIL is set. */
>> +               if (power->has_acin_path_sel) {
> 
> Do we need to check this bit if ACIN_AVAIL is not set?

No, we don't. However due to regcache this won't actually cause another read
from the device. If I send a v3, I'll move the && to  the if statement.

>> +                       ret = regmap_read(power->regmap, AXP813_ACIN_PATH_CTRL,
>> +                                         &reg);
>> +                       if (ret)
>> +                               return ret;
>> +
>> +                       val->intval &= !!(reg & AXP813_ACIN_PATH_SEL);
> 
> If we only check this bit if ACIN_AVAIL is set, then we don't need the
> "&" in the "&=". (I'm assuming that val->intval is an int, not a bool,
> otherwise this is the wrong operator)

val->intval is an int, but it only ever takes the values 0 or 1. The !!
expression coerces an integer to the range of a boolean. So the two ways of
deriving the value ("&=" here vs "&& val->intval" in the if statement) are
equivalent.

> Thanks,

Thanks!
Samuel

