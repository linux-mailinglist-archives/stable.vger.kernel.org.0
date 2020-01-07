Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9A13304F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 21:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgAGUIh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Jan 2020 15:08:37 -0500
Received: from 7.mo177.mail-out.ovh.net ([46.105.61.149]:56826 "EHLO
        7.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgAGUIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 15:08:36 -0500
X-Greylist: delayed 2352 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jan 2020 15:08:36 EST
Received: from player718.ha.ovh.net (unknown [10.108.16.103])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id 9323711BE75
        for <stable@vger.kernel.org>; Tue,  7 Jan 2020 20:29:22 +0100 (CET)
Received: from armadeus.com (91-171-241-78.subs.proxad.net [91.171.241.78])
        (Authenticated sender: sebastien.szymanski@armadeus.com)
        by player718.ha.ovh.net (Postfix) with ESMTPSA id 08099DDDD523;
        Tue,  7 Jan 2020 19:29:13 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.40.2.2.4\))
Subject: Re: [PATCH AUTOSEL 4.19 102/177] nvmem: imx-ocotp: reset error status
 on probe
From:   =?utf-8?Q?S=C3=A9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>
In-Reply-To: <2dc7001f362358dfdcbef080118b23cabaa03a40.camel@pengutronix.de>
Date:   Tue, 7 Jan 2020 20:29:12 +0100
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Fabio Estevam <festevam@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <CF40B493-27C8-4DF4-BB43-624CC797B12C@armadeus.com>
References: <20191210213221.11921-1-sashal@kernel.org>
 <20191210213221.11921-102-sashal@kernel.org>
 <dd048e02-81f7-8aed-34a7-f95a70859391@armadeus.com>
 <2dc7001f362358dfdcbef080118b23cabaa03a40.camel@pengutronix.de>
To:     Lucas Stach <l.stach@pengutronix.de>
X-Mailer: Apple Mail (2.3608.40.2.2.4)
X-Ovh-Tracer-Id: 15857737239658386631
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvdehiedgtdekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurheptggguffhjgffgffkfhfvofesthhqmhdthhdtjeenucfhrhhomhepuforsggrshhtihgvnhgpufiihihmrghnshhkihcuoehsvggsrghsthhivghnrdhsiiihmhgrnhhskhhisegrrhhmrgguvghushdrtghomheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpphgrshhtvggsihhnrdgtohhmnecukfhppedtrddtrddtrddtpdeluddrudejuddrvdeguddrjeeknecurfgrrhgrmhepmhhouggvpehsmhhtphdqohhuthdphhgvlhhopehplhgrhigvrhejudekrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshgvsggrshhtihgvnhdrshiihihmrghnshhkihesrghrmhgruggvuhhsrdgtohhmpdhrtghpthhtohepshhtrggslhgvsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Lucas,

> On 7 Jan 2020, at 18:53, Lucas Stach <l.stach@pengutronix.de> wrote:
> 
> Hi Sébastien,
> 
> On Di, 2020-01-07 at 15:50 +0100, Sébastien Szymanski wrote:
>> On 12/10/19 10:31 PM, Sasha Levin wrote:
>>> From: Lucas Stach <l.stach@pengutronix.de>
>>> 
>>> [ Upstream commit c33c585f1b3a99d53920bdac614aca461d8db06f ]
>>> 
>>> If software running before the OCOTP driver is loaded left the
>>> controller with the error status pending, the driver will never
>>> be able to complete the read timing setup. Reset the error status
>>> on probe to make sure the controller is in usable state.
>>> 
>>> Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
>>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>> Link: https://lore.kernel.org/r/20191029114240.14905-6-srinivas.kandagatla@linaro.org
>>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>> drivers/nvmem/imx-ocotp.c | 4 ++++
>>> 1 file changed, 4 insertions(+)
>>> 
>>> diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
>>> index afb429a417fe0..926d9cc080cf4 100644
>>> --- a/drivers/nvmem/imx-ocotp.c
>>> +++ b/drivers/nvmem/imx-ocotp.c
>>> @@ -466,6 +466,10 @@ static int imx_ocotp_probe(struct platform_device *pdev)
>>> 	if (IS_ERR(priv->clk))
>>> 		return PTR_ERR(priv->clk);
>>> 
>>> +	clk_prepare_enable(priv->clk);
>>> +	imx_ocotp_clr_err_if_set(priv->base);
>>> +	clk_disable_unprepare(priv->clk);
>>> +
>>> 	priv->params = of_device_get_match_data(&pdev->dev);
>>> 	imx_ocotp_nvmem_config.size = 4 * priv->params->nregs;
>>> 	imx_ocotp_nvmem_config.dev = dev;
>>> 
>> 
>> Hi,
>> 
>> This patch makes kernel 4.19.{92,93} hang at boot on my i.MX6ULL based
>> board. It hanks at
>> 
>> [    3.730078] cpu cpu0: Linked as a consumer to regulator.2
>> [    3.737760] cpu cpu0: Linked as a consumer to regulator.3
>> 
>> Full boot log is here: https://pastebin.com/TS8EFxkr
>> 
>> The config is imx_v6_v7_defconfig.
>> 
>> Reverting it makes the kernels boot again.
> 
> Can you check if it actually hangs in imx_ocotp_clr_err_if_set(), or if
> the clk_disable_unprepare() is the culprit?
> 
> If the clock disable hangs the system there is a missing clock
> reference somewhere else that we need to track down.

Yes, the system hangs in the imx6q-cpufreq driver, here:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/drivers/cpufreq/imx6q-cpufreq.c?h=v4.19.93#n322

Kernel 5.4.8 works thanks to commits:

2733fb0d0699 (“cpufreq: imx6q: read OCOTP through nvmem for imx6ul/imx6ull”)
92f0eb08c66a ("ARM: dts: imx6ul: use nvmem-cells for cpu speed grading”)

Regards,

-- 
Sébastien Szymanski, Armadeus Systems
Software engineer

> 
> Regards,
> Lucas
> 

