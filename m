Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3DC567ED7
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 08:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbiGFGoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 02:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiGFGoB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 02:44:01 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB37E1836A;
        Tue,  5 Jul 2022 23:44:00 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id o4so20553207wrh.3;
        Tue, 05 Jul 2022 23:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4jwvmj1pp+GjRzWGjVPIaD2zx1OzglEoesXu15FzsLo=;
        b=CWrqX0z0bxlea48ov1zxt8KGOwoPpvw/rQGKGYDwXHOaEcwW3iuuE4zCb+FY1pBwGQ
         tf+OUt0/bJ2z+6Z+kMIWnGTVbTcybEul3ytR14dvLRwcl3uoVUmv0fF1+1mf9L+aSGur
         bafBQgdh62Ce09TUB6tjKwGXssDTZujaODWHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4jwvmj1pp+GjRzWGjVPIaD2zx1OzglEoesXu15FzsLo=;
        b=ESXbIK02PFHZHj5FNlZXQzSniZ/LBgbyhCyHCqd0XQWCdzPPdGzg6yfiBMIhBgZnAE
         0xfqU011ZPqPW3/HDu29UqeSBGF9y8/8/KJD41OZs/tAbxQvn+NwGiRg8CLNBPsdCQnZ
         KTMbOHTyQpj9YYBCyM0yONbeWTqZJgZA2ad+L2mQ7V/AfrZppBqmTicQZeyGrl5b3sKi
         EY7gsTxdNUeTYGZ4nLj3oeqRwPD+AfYwWsbqEEcH6hLvtXorkVn1gCVtmSjiqdU6aRcH
         QxUZwyyyjFREtvSUDU/ics2x+X3OK5ECGw97BXPqFk2J14UtrA9F4tC7x9RI5iC6K4NW
         eO+A==
X-Gm-Message-State: AJIora/98Hq7r0NuQXo6+wAvNtJ9In2VdvT46GP0XLppndfa6XSBOnoe
        qNlrxaXDQjPERmsrD1WuDPIdcQ1POek/BLYv3WE=
X-Google-Smtp-Source: AGRyM1uVmvHyQuqipT+NDCpQ86ZMLF1Uu8iyiixWuraKKpfqAdRINQbt1Yg703PoIZGKW2ir1GTlh0GoyiPdDqUDFe0=
X-Received: by 2002:a05:6000:993:b0:21b:8f16:5b3f with SMTP id
 by19-20020a056000099300b0021b8f165b3fmr33562123wrb.628.1657089839060; Tue, 05
 Jul 2022 23:43:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220705115617.568350164@linuxfoundation.org> <20220705115620.297922907@linuxfoundation.org>
In-Reply-To: <20220705115620.297922907@linuxfoundation.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Wed, 6 Jul 2022 06:43:47 +0000
Message-ID: <CACPK8Xf0eujAq_oHzQn15hZyTL+QtDEaL5eUFCiODS+C06fW2Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 96/98] hwmon: (occ) Remove sequence numbering and
 checksum calculation
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Eddie James <eajames@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Jul 2022 at 12:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Eddie James <eajames@linux.ibm.com>
>
> [ Upstream commit 908dbf0242e21dd95c69a1b0935814cd1abfc134 ]
>
> Checksumming of the request and sequence numbering is now done in the
> OCC interface driver in order to keep unique sequence numbers. So
> remove those in the hwmon driver. Also, add the command length to the
> send_cmd function pointer, since the checksum must be placed in the
> last two bytes of the command. The submit interface must receive the
> exact size of the command - previously it could be rounded to the
> nearest 8 bytes with no consequence.
>
> Signed-off-by: Eddie James <eajames@linux.ibm.com>
> Acked-by: Guenter Roeck <linux@roeck-us.net>
> Link: https://lore.kernel.org/r/20210721190231.117185-3-eajames@linux.ibm.com
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

If this patch is being backported then we must also backport:

  62f79f3d0eb9 ("fsi: occ: Force sequence numbering per OCC")

I was only cc'd on this one so I assume that means 62f79f3d0eb9 is not
already in the queue.

> ---
>  drivers/hwmon/occ/common.c | 30 ++++++++++++------------------
>  drivers/hwmon/occ/common.h |  3 +--
>  drivers/hwmon/occ/p8_i2c.c | 15 +++++++++------
>  drivers/hwmon/occ/p9_sbe.c |  4 ++--
>  4 files changed, 24 insertions(+), 28 deletions(-)
>
> diff --git a/drivers/hwmon/occ/common.c b/drivers/hwmon/occ/common.c
> index ae664613289c..0cb4a0a6cbc1 100644
> --- a/drivers/hwmon/occ/common.c
> +++ b/drivers/hwmon/occ/common.c
> @@ -132,22 +132,20 @@ struct extended_sensor {
>  static int occ_poll(struct occ *occ)
>  {
>         int rc;
> -       u16 checksum = occ->poll_cmd_data + occ->seq_no + 1;
> -       u8 cmd[8];
> +       u8 cmd[7];
>         struct occ_poll_response_header *header;
>
>         /* big endian */
> -       cmd[0] = occ->seq_no++;         /* sequence number */
> +       cmd[0] = 0;                     /* sequence number */
>         cmd[1] = 0;                     /* cmd type */
>         cmd[2] = 0;                     /* data length msb */
>         cmd[3] = 1;                     /* data length lsb */
>         cmd[4] = occ->poll_cmd_data;    /* data */
> -       cmd[5] = checksum >> 8;         /* checksum msb */
> -       cmd[6] = checksum & 0xFF;       /* checksum lsb */
> -       cmd[7] = 0;
> +       cmd[5] = 0;                     /* checksum msb */
> +       cmd[6] = 0;                     /* checksum lsb */
>
>         /* mutex should already be locked if necessary */
> -       rc = occ->send_cmd(occ, cmd);
> +       rc = occ->send_cmd(occ, cmd, sizeof(cmd));
>         if (rc) {
>                 occ->last_error = rc;
>                 if (occ->error_count++ > OCC_ERROR_COUNT_THRESHOLD)
> @@ -184,25 +182,23 @@ static int occ_set_user_power_cap(struct occ *occ, u16 user_power_cap)
>  {
>         int rc;
>         u8 cmd[8];
> -       u16 checksum = 0x24;
>         __be16 user_power_cap_be = cpu_to_be16(user_power_cap);
>
> -       cmd[0] = 0;
> -       cmd[1] = 0x22;
> -       cmd[2] = 0;
> -       cmd[3] = 2;
> +       cmd[0] = 0;     /* sequence number */
> +       cmd[1] = 0x22;  /* cmd type */
> +       cmd[2] = 0;     /* data length msb */
> +       cmd[3] = 2;     /* data length lsb */
>
>         memcpy(&cmd[4], &user_power_cap_be, 2);
>
> -       checksum += cmd[4] + cmd[5];
> -       cmd[6] = checksum >> 8;
> -       cmd[7] = checksum & 0xFF;
> +       cmd[6] = 0;     /* checksum msb */
> +       cmd[7] = 0;     /* checksum lsb */
>
>         rc = mutex_lock_interruptible(&occ->lock);
>         if (rc)
>                 return rc;
>
> -       rc = occ->send_cmd(occ, cmd);
> +       rc = occ->send_cmd(occ, cmd, sizeof(cmd));
>
>         mutex_unlock(&occ->lock);
>
> @@ -1144,8 +1140,6 @@ int occ_setup(struct occ *occ, const char *name)
>  {
>         int rc;
>
> -       /* start with 1 to avoid false match with zero-initialized SRAM buffer */
> -       occ->seq_no = 1;
>         mutex_init(&occ->lock);
>         occ->groups[0] = &occ->group;
>
> diff --git a/drivers/hwmon/occ/common.h b/drivers/hwmon/occ/common.h
> index e6df719770e8..5020117be740 100644
> --- a/drivers/hwmon/occ/common.h
> +++ b/drivers/hwmon/occ/common.h
> @@ -95,9 +95,8 @@ struct occ {
>         struct occ_sensors sensors;
>
>         int powr_sample_time_us;        /* average power sample time */
> -       u8 seq_no;
>         u8 poll_cmd_data;               /* to perform OCC poll command */
> -       int (*send_cmd)(struct occ *occ, u8 *cmd);
> +       int (*send_cmd)(struct occ *occ, u8 *cmd, size_t len);
>
>         unsigned long next_update;
>         struct mutex lock;              /* lock OCC access */
> diff --git a/drivers/hwmon/occ/p8_i2c.c b/drivers/hwmon/occ/p8_i2c.c
> index 0cf8588be35a..9e61e1fb5142 100644
> --- a/drivers/hwmon/occ/p8_i2c.c
> +++ b/drivers/hwmon/occ/p8_i2c.c
> @@ -97,18 +97,21 @@ static int p8_i2c_occ_putscom_u32(struct i2c_client *client, u32 address,
>  }
>
>  static int p8_i2c_occ_putscom_be(struct i2c_client *client, u32 address,
> -                                u8 *data)
> +                                u8 *data, size_t len)
>  {
> -       __be32 data0, data1;
> +       __be32 data0 = 0, data1 = 0;
>
> -       memcpy(&data0, data, 4);
> -       memcpy(&data1, data + 4, 4);
> +       memcpy(&data0, data, min_t(size_t, len, 4));
> +       if (len > 4) {
> +               len -= 4;
> +               memcpy(&data1, data + 4, min_t(size_t, len, 4));
> +       }
>
>         return p8_i2c_occ_putscom_u32(client, address, be32_to_cpu(data0),
>                                       be32_to_cpu(data1));
>  }
>
> -static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
> +static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
>  {
>         int i, rc;
>         unsigned long start;
> @@ -127,7 +130,7 @@ static int p8_i2c_occ_send_cmd(struct occ *occ, u8 *cmd)
>                 return rc;
>
>         /* write command (expected to already be BE), we need bus-endian... */
> -       rc = p8_i2c_occ_putscom_be(client, OCB_DATA3, cmd);
> +       rc = p8_i2c_occ_putscom_be(client, OCB_DATA3, cmd, len);
>         if (rc)
>                 return rc;
>
> diff --git a/drivers/hwmon/occ/p9_sbe.c b/drivers/hwmon/occ/p9_sbe.c
> index f6387cc0b754..9709f2b9c052 100644
> --- a/drivers/hwmon/occ/p9_sbe.c
> +++ b/drivers/hwmon/occ/p9_sbe.c
> @@ -16,14 +16,14 @@ struct p9_sbe_occ {
>
>  #define to_p9_sbe_occ(x)       container_of((x), struct p9_sbe_occ, occ)
>
> -static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd)
> +static int p9_sbe_occ_send_cmd(struct occ *occ, u8 *cmd, size_t len)
>  {
>         struct occ_response *resp = &occ->resp;
>         struct p9_sbe_occ *ctx = to_p9_sbe_occ(occ);
>         size_t resp_len = sizeof(*resp);
>         int rc;
>
> -       rc = fsi_occ_submit(ctx->sbe, cmd, 8, resp, &resp_len);
> +       rc = fsi_occ_submit(ctx->sbe, cmd, len, resp, &resp_len);
>         if (rc < 0)
>                 return rc;
>
> --
> 2.35.1
>
>
>
