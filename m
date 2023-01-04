Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1F865DB52
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 18:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230198AbjADRho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 12:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbjADRhh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 12:37:37 -0500
X-Greylist: delayed 75461 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 04 Jan 2023 09:37:36 PST
Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA5139FB9
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 09:37:36 -0800 (PST)
Date:   Wed, 04 Jan 2023 17:37:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1672853853; x=1673113053;
        bh=VeUqwPJjSgTsI+EilQ6YYMEsDrMHP5sLjuX2kURHJWE=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=RGRPk9TWIqPruEDcxkCDkUMP/q2vbfwfWhTmhITgOR5DfUOa3I557eBjmtXokqDU5
         /1jrCiWT3Yh1o4o5jaqjfeWbVQFbMQkkEVPQSl67qRCwlSomRTqIRtu9KhbHP7umgN
         aeyuSEEzkgJJXYQbETTQtkLSVYJv7ZBqxtxivy9xHLmPbhJNhthplaejjcrSY6sUCh
         qUkNWhtLewHvXFqk2Fp7c4lcO9q+ACDGuX9CokdZy2RIOxarb1u228emQpqiB4+mqZ
         5Gx0jpqy3sZdYB+6ewWRI3zUyhKe3gGmRd2HREsJwJdXc6B2P2PI++WyCIrhzw0d7W
         Ia1660c+ehMIg==
To:     Takashi Iwai <tiwai@suse.de>
From:   waldek andrukiewicz <waldek.andrukiewicz@protonmail.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev,
        Stefan Binding <sbinding@opensource.cirrus.com>,
        Richard Fitzgerald <rf@opensource.cirrus.com>,
        Lucas Tanure <tanureal@opensource.cirrus.com>
Subject: Re: i2c-CLSA0100:00-cs35l41-hda.1: System Suspend not supported
Message-ID: <1fb50261-8cf0-2953-2c1a-f7e16cd12d5d@protonmail.com>
In-Reply-To: <874jt6ps04.wl-tiwai@suse.de>
References: <4262e3c4-6169-bbd2-e918-16b06f6994bc@protonmail.com> <874jt6ps04.wl-tiwai@suse.de>
Feedback-ID: 6277459:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 04.01.23 10:29, Takashi Iwai wrote:
> [ adding Cirrus people to Cc ]
>
> On Tue, 03 Jan 2023 21:39:42 +0100,
> waldek andrukiewicz wrote:
>> Hello,
>>
>> I am running Manjaro, after upgrading from kernel 6.0.15 to 6.1.1 (
>> https://gitlab.manjaro.org/packages/core/linux61) I have noticed that su=
spend
>> stopped working, what I can see in the logs is the following issue which=
 IMO
>> points to cs35l41
>>
>> Machine:
>>  =C2=A0 Type: Laptop System: LENOVO product: 82N6 v: Legion 7 16ACHg6
>>
>> journalctl output below:
>>
>> Jan 02 21:52:54 legion16 systemd[1]: Starting System Suspend...
>> Jan 02 21:52:54 legion16 wpa_supplicant[1193]: wlp4s0: CTRL-EVENT-DSCP-P=
OLICY
>> clear_all
>> Jan 02 21:52:54 legion16 systemd-sleep[2912]: Entering sleep state
>> 'suspend'...
>> Jan 02 21:52:54 legion16 kernel: PM: suspend entry (deep)
>> Jan 02 21:52:54 legion16 kernel: Filesystems sync: 0.008 seconds
>> Jan 02 21:52:54 legion16 wpa_supplicant[1193]: wlp4s0: CTRL-EVENT-DSCP-P=
OLICY
>> clear_all
>> Jan 02 21:52:54 legion16 wpa_supplicant[1193]: nl80211: deinit ifname=3D=
wlp4s0
>> disabled_11b_rates=3D0
>> Jan 02 21:52:54 legion16 plasmashell[1770]: qml: [DEBUG] - onNewData
>> Jan 02 21:52:54 legion16 kernel: Freezing user space processes ... (elap=
sed
>> 0.002 seconds) done.
>> Jan 02 21:52:54 legion16 kernel: OOM killer disabled.
>> Jan 02 21:52:54 legion16 kernel: Freezing remaining freezable tasks ...
>> (elapsed 0.001 seconds) done.
>> Jan 02 21:52:54 legion16 kernel: printk: Suspending console(s) (use
>> no_console_suspend to debug)
>> Jan 02 21:52:54 legion16 kernel: cs35l41-hda i2c-CLSA0100:00-cs35l41-hda=
.1:
>> System Suspend not supported
>> Jan 02 21:52:54 legion16 kernel: cs35l41-hda i2c-CLSA0100:00-cs35l41-hda=
.0:
>> System Suspend not supported
>> Jan 02 21:52:54 legion16 kernel: cs35l41-hda i2c-CLSA0100:00-cs35l41-hda=
.1:
>> PM: dpm_run_callback(): cs35l41_system_suspend+0x0/0xd0
>> [snd_hda_scodec_cs35l41] returns -22
> Indeed the suspend isn't supported for this chip wrt the specific
> model/config, but it's a bad behavior to block the whole system
> suspend due to that.
>
> Could you try the patch below?
>
>
> Takashi
>
> -- 8< --
> diff --git a/sound/pci/hda/cs35l41_hda.c b/sound/pci/hda/cs35l41_hda.c
> index 91842c0c8c74..6322157c7ea2 100644
> --- a/sound/pci/hda/cs35l41_hda.c
> +++ b/sound/pci/hda/cs35l41_hda.c
> @@ -598,8 +598,8 @@ static int cs35l41_system_suspend(struct device *dev)
>   =09dev_dbg(cs35l41->dev, "System Suspend\n");
>
>   =09if (cs35l41->hw_cfg.bst_type =3D=3D CS35L41_EXT_BOOST_NO_VSPK_SWITCH=
) {
> -=09=09dev_err(cs35l41->dev, "System Suspend not supported\n");
> -=09=09return -EINVAL;
> +=09=09dev_err_once(cs35l41->dev, "System Suspend not supported\n");
> +=09=09return 0; /* don't block the whole system suspend */
>   =09}
>
>   =09ret =3D pm_runtime_force_suspend(dev);
> @@ -624,8 +624,8 @@ static int cs35l41_system_resume(struct device *dev)
>   =09dev_dbg(cs35l41->dev, "System Resume\n");
>
>   =09if (cs35l41->hw_cfg.bst_type =3D=3D CS35L41_EXT_BOOST_NO_VSPK_SWITCH=
) {
> -=09=09dev_err(cs35l41->dev, "System Resume not supported\n");
> -=09=09return -EINVAL;
> +=09=09dev_err_once(cs35l41->dev, "System Resume not supported\n");
> +=09=09return 0; /* don't block the whole system resume */
>   =09}
>
>   =09if (cs35l41->reset_gpio) {
> @@ -647,6 +647,15 @@ static int cs35l41_system_resume(struct device *dev)
>   =09return ret;
>   }
>
> +static int cs35l41_runtime_idle(struct device *dev)
> +{
> +=09struct cs35l41_hda *cs35l41 =3D dev_get_drvdata(dev);
> +
> +=09if (cs35l41->hw_cfg.bst_type =3D=3D CS35L41_EXT_BOOST_NO_VSPK_SWITCH)
> +=09=09return -EBUSY; /* suspend not supported yet on this model */
> +=09return 0;
> +}
> +
>   static int cs35l41_runtime_suspend(struct device *dev)
>   {
>   =09struct cs35l41_hda *cs35l41 =3D dev_get_drvdata(dev);
> @@ -1536,7 +1545,8 @@ void cs35l41_hda_remove(struct device *dev)
>   EXPORT_SYMBOL_NS_GPL(cs35l41_hda_remove, SND_HDA_SCODEC_CS35L41);
>
>   const struct dev_pm_ops cs35l41_hda_pm_ops =3D {
> -=09RUNTIME_PM_OPS(cs35l41_runtime_suspend, cs35l41_runtime_resume, NULL)
> +=09RUNTIME_PM_OPS(cs35l41_runtime_suspend, cs35l41_runtime_resume,
> +=09=09       cs35l41_runtime_idle)
>   =09SYSTEM_SLEEP_PM_OPS(cs35l41_system_suspend, cs35l41_system_resume)
>   };
>   EXPORT_SYMBOL_NS_GPL(cs35l41_hda_pm_ops, SND_HDA_SCODEC_CS35L41);


Hi Takashi,

Thank you for your prompt reply, I decided to patch the Manjaro 6.1.3
kernel and in case the issue persisted, try the same with mainline but
it helped. I can suspend/resume the laptop same as I could with pre 6.1
kernels.

If you are interested in any logs from my system let me know.

Best Regards,

Waldek Andrukiewicz


