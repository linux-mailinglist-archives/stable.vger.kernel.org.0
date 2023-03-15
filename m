Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC466BBE23
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 21:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbjCOUuU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 16:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjCOUuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 16:50:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AEB619112;
        Wed, 15 Mar 2023 13:50:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c10so12503536pfv.13;
        Wed, 15 Mar 2023 13:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678913417;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBuA/oviiAKogWaalHUVA/HWn23TAnJcudZ+udGzOjA=;
        b=btpyzlJvp3OkMxIs8sPoD5lm/PvHCCw+Hk0w0ikpXkP8VnMBVHXlJ4BWcwJs8Z+Tbu
         CHpxSFKrkWJ/kEen5IpqdptGTPVtLUucZVrMJmGGNiUkkWezNNAqRN4hJBOtAjM4Iq/J
         aWIE0kZuWqjcEBF68OSi+CTE8r9dLgGg2KCfccCOBvgRBdIKXxE6c8YxGV4McIvQVaQ3
         dD83CC0HZu9klNOqrnwTiHMiCzPHiBOvnF9YFU+/nlIScHVRV0BHbP+70W6YTrJP6icu
         fecUn4HsgtePlxhxScIOLTcejRT9+O5MvnXkk5asOO9jTWIKm22TKf+pTU6ZBmRVD3QN
         CYCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678913417;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RBuA/oviiAKogWaalHUVA/HWn23TAnJcudZ+udGzOjA=;
        b=vVMso20ERCj1LQlMcND+Xl0GA4jQwocS7ulNKacqhjHYaMR0JVx65iBxb7wutpoopb
         s/jgvi8c3iPD2gSsYOn4+bPnhVFSrIdgE9uYCQDJHN0mikwD8GR/wM4MOS3byEWa54eN
         SCdadj3oyKO7SsqmsZgIjg5OcYGlemoltA60ki9aBpKoMsuCQXuqLKjzzrtsABVAsUmz
         Ym9tB1fIfUwEorO4bhbPwxWsvO7ZALvH1Cd9hi8aMgRqCozqTU/F16wxW3wKI7QE7qBf
         oVP4z2bTwvzT5c26LmSRZEegk3YK0lW4pg0qSI8ShoBF8hR2FZAteuO/lOetRffF4o6W
         IGUA==
X-Gm-Message-State: AO0yUKXWtxJJIUaVcMiWRzIJIk+umqzPumpBRm3YiQW0aTwXENolBV5M
        sFmhgnOaWldGz7vESExxKBTXTGfmo+jJLw==
X-Google-Smtp-Source: AK7set/K2Xlza1JfWQR1HoQteInsv7KAx1jfAT6OLX50J7CXJ3jYGGD3DlXRfV00qZwOXqWarEK4nw==
X-Received: by 2002:aa7:8f3a:0:b0:5a8:bbac:1cf2 with SMTP id y26-20020aa78f3a000000b005a8bbac1cf2mr762553pfr.1.1678913417209;
        Wed, 15 Mar 2023 13:50:17 -0700 (PDT)
Received: from [172.30.1.89] ([14.32.163.5])
        by smtp.gmail.com with ESMTPSA id t15-20020aa7938f000000b005a817f72c21sm3963317pfe.131.2023.03.15.13.50.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 13:50:16 -0700 (PDT)
Message-ID: <794faacb-b3b3-9d9e-8620-ab2067851f88@gmail.com>
Date:   Thu, 16 Mar 2023 05:50:11 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2] extcon: usbc-tusb320: unregister typec port on driver
 removal
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Marek Vasut <marex@denx.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230315141547.825057-1-alvin@pqrs.dk>
From:   Chanwoo Choi <cwchoi00@gmail.com>
Content-Language: en-US
In-Reply-To: <20230315141547.825057-1-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 23. 3. 15. 23:15, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> The driver can register a typec port if suitable firmware properties are
> present. But if the driver is removed through sysfs unbind, rmmod or
> similar, then it does not clean up after itself and the typec port
> device remains registered. This can be seen in sysfs, where stale typec
> ports get left over in /sys/class/typec.
> 
> In order to fix this we have to add an i2c_driver remove function and
> call typec_unregister_port(), which is a no-op in the case where no
> typec port is created and the pointer remains NULL.
> 
> In the process we should also put the fwnode_handle when the typec port
> isn't registered anymore, including if an error occurs during probe. The
> typec subsystem does not increase or decrease the reference counter for
> us, so we track it in the driver's private data.
> 
> Note that the conditional check on TYPEC_PWR_MODE_PD was removed in the
> probe path because a call to tusb320_set_adv_pwr_mode() will perform an
> even more robust validation immediately after, hence there is no
> functional change here.
> 
> Fixes: bf7571c00dca ("extcon: usbc-tusb320: Add USB TYPE-C support")
> Cc: stable@vger.kernel.org
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> ---
> v2: properly assign priv->connector_fwnode = connector;
> ---
>  drivers/extcon/extcon-usbc-tusb320.c | 42 ++++++++++++++++++++++------
>  1 file changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/extcon/extcon-usbc-tusb320.c b/drivers/extcon/extcon-usbc-tusb320.c
> index b408ce989c22..10dff1c512c4 100644
> --- a/drivers/extcon/extcon-usbc-tusb320.c
> +++ b/drivers/extcon/extcon-usbc-tusb320.c
> @@ -78,6 +78,7 @@ struct tusb320_priv {
>  	struct typec_capability	cap;
>  	enum typec_port_type port_type;
>  	enum typec_pwr_opmode pwr_opmode;
> +	struct fwnode_handle *connector_fwnode;
>  };
>  
>  static const char * const tusb_attached_states[] = {
> @@ -391,27 +392,25 @@ static int tusb320_typec_probe(struct i2c_client *client,
>  	/* Type-C connector found. */
>  	ret = typec_get_fw_cap(&priv->cap, connector);
>  	if (ret)
> -		return ret;
> +		goto err_put;
>  
>  	priv->port_type = priv->cap.type;
>  
>  	/* This goes into register 0x8 field CURRENT_MODE_ADVERTISE */
>  	ret = fwnode_property_read_string(connector, "typec-power-opmode", &cap_str);
>  	if (ret)
> -		return ret;
> +		goto err_put;
>  
>  	ret = typec_find_pwr_opmode(cap_str);
>  	if (ret < 0)
> -		return ret;
> -	if (ret == TYPEC_PWR_MODE_PD)
> -		return -EINVAL;
> +		goto err_put;
>  
>  	priv->pwr_opmode = ret;
>  
>  	/* Initialize the hardware with the devicetree settings. */
>  	ret = tusb320_set_adv_pwr_mode(priv);
>  	if (ret)
> -		return ret;
> +		goto err_put;
>  
>  	priv->cap.revision		= USB_TYPEC_REV_1_1;
>  	priv->cap.accessory[0]		= TYPEC_ACCESSORY_AUDIO;
> @@ -422,10 +421,25 @@ static int tusb320_typec_probe(struct i2c_client *client,
>  	priv->cap.fwnode		= connector;
>  
>  	priv->port = typec_register_port(&client->dev, &priv->cap);
> -	if (IS_ERR(priv->port))
> -		return PTR_ERR(priv->port);
> +	if (IS_ERR(priv->port)) {
> +		ret = PTR_ERR(priv->port);
> +		goto err_put;
> +	}
> +
> +	priv->connector_fwnode = connector;
>  
>  	return 0;
> +
> +err_put:
> +	fwnode_handle_put(connector);
> +
> +	return ret;
> +}
> +
> +static void tusb320_typec_remove(struct tusb320_priv *priv)
> +{
> +	typec_unregister_port(priv->port);
> +	fwnode_handle_put(priv->connector_fwnode);
>  }
>  
>  static int tusb320_probe(struct i2c_client *client)
> @@ -438,7 +452,9 @@ static int tusb320_probe(struct i2c_client *client)
>  	priv = devm_kzalloc(&client->dev, sizeof(*priv), GFP_KERNEL);
>  	if (!priv)
>  		return -ENOMEM;
> +
>  	priv->dev = &client->dev;
> +	i2c_set_clientdata(client, priv);
>  
>  	priv->regmap = devm_regmap_init_i2c(client, &tusb320_regmap_config);
>  	if (IS_ERR(priv->regmap))
> @@ -489,10 +505,19 @@ static int tusb320_probe(struct i2c_client *client)
>  					tusb320_irq_handler,
>  					IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
>  					client->name, priv);
> +	if (ret)
> +		tusb320_typec_remove(priv);
>  
>  	return ret;
>  }
>  
> +static void tusb320_remove(struct i2c_client *client)
> +{
> +	struct tusb320_priv *priv = i2c_get_clientdata(client);
> +
> +	tusb320_typec_remove(priv);
> +}
> +
>  static const struct of_device_id tusb320_extcon_dt_match[] = {
>  	{ .compatible = "ti,tusb320", .data = &tusb320_ops, },
>  	{ .compatible = "ti,tusb320l", .data = &tusb320l_ops, },
> @@ -502,6 +527,7 @@ MODULE_DEVICE_TABLE(of, tusb320_extcon_dt_match);
>  
>  static struct i2c_driver tusb320_extcon_driver = {
>  	.probe_new	= tusb320_probe,
> +	.remove		= tusb320_remove,
>  	.driver		= {
>  		.name	= "extcon-tusb320",
>  		.of_match_table = tusb320_extcon_dt_match,

Applied it. Thanks.

-- 
Best Regards,
Samsung Electronics
Chanwoo Choi

