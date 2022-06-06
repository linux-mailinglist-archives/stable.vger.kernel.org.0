Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9DD53EB1F
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236226AbiFFMC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 08:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbiFFMCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 08:02:24 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D18ED5FF4;
        Mon,  6 Jun 2022 05:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654516934;
        bh=eL5kkVKKYcpReAYFFCPPQ5dnNHzUQyRBee9P97oXtkE=;
        h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
        b=CblmNRUAjBfrY4z60anCkbcXEwz3pjdNTJRB4Ul/M3qE7Ps0HQovq+BhexxD5jkZE
         kwPwNZs1TuwAvqfJfC37aK9HQn8t2mfvYBpftkX8e3NUNswGgKIc+WIZaAqKYPjAZD
         pwMckrTcotk+cYEuJywhLAqDsOo7cuy6r8iVinDs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([149.28.201.231]) by mail.gmx.net (mrgmx004
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MUXpK-1oOTjB0PGS-00QSj8; Mon, 06
 Jun 2022 14:02:14 +0200
Message-ID: <9bd0a9d5-cbba-4f1b-1624-42ce368e06c2@gmx.com>
Date:   Mon, 6 Jun 2022 20:02:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] btrfs: add error messages to all unrecognized mount
 options
Content-Language: en-US
To:     David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20220606110819.3943-1-dsterba@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
In-Reply-To: <20220606110819.3943-1-dsterba@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:CiQl0+eUxoscmtkyCLHxBaXwsCtecfa4l4RXBvKsjda82S6U3+N
 ebRe5irxUaiczVJ3Ipdak4IsmbjwuMQGlHb3TATIoKtdVV6dSsW7H5sVIxZxTiT34EYodCR
 ZWfgvuYS6oH8q1pdV83Ht1rqONV7UD4NvhbZ0rgiuX4l3JdoEolJ4L4L5lRXx3jxhxKwQyS
 CZ+xB8zzNLiQoTV8/mgEA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Jx/Wu5kV8MM=:1xy//Uw7XvrNR4YSPakJwm
 opBsNz13aj1sdOUyQdQ1UGmpk0q3GHJPjz5xJRJ3nKYV/uxvwpf6bmGOxqYmx6nixB6fdFt2o
 WqoWw455OmC9cPNwCZJauafCnWGkyTOn3K1Xy5NUYzU8pNbcpLbHIjvGgDrerorzkYFW6AyE3
 eKqGN8zLHZ3FmErK2cHL0Lsb366QOhVkD6oW2FauQyeNfOBxRoOL1yZDv45no02p1spScvdZJ
 sauTmvvjv4/5Pu6SXm84of8dWIMG/kitMgV0Yv3YUWD84S+tdDTwzDHXbe/Ak7g8pfA6c2EXm
 KgPwioxfQ3qUBGub6bjJ+IE9sr23rjd+VXJceiCHja5BoZeFW3XGvRGfprQy3YOd+GAcQkEvs
 paKNvHze2SsA/5uKFLLHiQCIWKJtsaSZnfbE4psSf5HWqCWI0zcCRsqaHpSVNFHWQtbw/SQlN
 esfu1U8r0MRqBNX7JsXXJW4aI2O2J4w8Sdv7znVEAwurnyAwWNCVzqz/itej5pZ/3jsM93wZ8
 nLIBCENIono/78EgayTZlEvpC7bfRj4wQY+BayLAJYFc6Nmez19XD2tJB2IuX1vslUdij/llM
 tP6gqTxRXJWNYpUE/WLrLuEfhCUemJm3xELy8p/iGeTn27C96MuRqY4gWT8FTDVZfLxobvEqp
 dUY6cFxOReecbrGhKSEmWAF5x39T0y3NnkSgOs67REWYW6H+5a5fLtw/4wHaDr0jZ0D49oQH/
 21fcpHOq47mKY6Ccg7n8OTf7mvchjy4re0t2bvW3Xrx4nylQ76t+HcHxLNolUrH42SW9BTuSF
 dIpRrhB3RambUaxW4FpyWwYjwbiEZTwFDYaLzAGG1ifh+C7oduYZFn4TeO7hNIaWGzu+3KE7r
 a/HRjdnltmlhLlOZOLJdoLjkFFr2CI58oDigdb1oFv/y3ctQi7y2X+tJ4RkJCusj0FE/AVJwf
 Rewv0uf4TkHrpUnRraVEYNzH4D4wDQv+EkD1GWBsVSsKhpzCV0NoaJVsm65HhC3Scx7TcmJb7
 jfVrDdm2Ubuo3APSaX8QRuEb2LahgeQsMI5aaKKmqHIx79JYyOGQ774w7W2PDh9HsIJYk53kV
 +1MXpt8CYpFRt8hm01GgBtEBLjypdkQVlFmSwO/U3av4U2sD9sa6vZcdQ==
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/6/6 19:08, David Sterba wrote:
> Almost none of the errors stemming from a valid mount option but wrong
> value prints a descriptive message which would help to identify why
> mount failed. Like in the linked report:
>
>    $ uname -r
>    v4.19
>    $ mount -o compress=3Dzstd /dev/sdb /mnt
>    mount: /mnt: wrong fs type, bad option, bad superblock on
>    /dev/sdb, missing codepage or helper program, or other error.
>    $ dmesg
>    ...
>    BTRFS error (device sdb): open_ctree failed
>
> Errors caused by memory allocation failures are left out as it's not a
> user error so reporting that would be confusing.
>
> Link: https://lore.kernel.org/linux-btrfs/9c3fec36-fc61-3a33-4977-a7e207=
c3fa4e@gmx.de/
> CC: stable@vger.kernel.org # 4.9+
> Signed-off-by: David Sterba <dsterba@suse.com>

Reviewed-by: Qu Wenruo <wqu@suse.com>

Thanks,
Qu
> ---
>   fs/btrfs/super.c | 39 ++++++++++++++++++++++++++++++++-------
>   1 file changed, 32 insertions(+), 7 deletions(-)
>
> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> index d8e2eac0417e..719dda57dc7a 100644
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -764,6 +764,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, =
char *options,
>   				compress_force =3D false;
>   				no_compress++;
>   			} else {
> +				btrfs_err(info, "unrecognized compression value %s",
> +					  args[0].from);
>   				ret =3D -EINVAL;
>   				goto out;
>   			}
> @@ -822,8 +824,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info,=
 char *options,
>   		case Opt_thread_pool:
>   			ret =3D match_int(&args[0], &intarg);
>   			if (ret) {
> +				btrfs_err(info, "unrecognized thread_pool value %s",
> +					  args[0].from);
>   				goto out;
>   			} else if (intarg =3D=3D 0) {
> +				btrfs_err(info, "invalid value 0 for thread_pool");
>   				ret =3D -EINVAL;
>   				goto out;
>   			}
> @@ -884,8 +889,11 @@ int btrfs_parse_options(struct btrfs_fs_info *info,=
 char *options,
>   			break;
>   		case Opt_ratio:
>   			ret =3D match_int(&args[0], &intarg);
> -			if (ret)
> +			if (ret) {
> +				btrfs_err(info, "unrecognized metadata_ratio value %s",
> +					  args[0].from);
>   				goto out;
> +			}
>   			info->metadata_ratio =3D intarg;
>   			btrfs_info(info, "metadata ratio %u",
>   				   info->metadata_ratio);
> @@ -902,6 +910,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, =
char *options,
>   				btrfs_set_and_info(info, DISCARD_ASYNC,
>   						   "turning on async discard");
>   			} else {
> +				btrfs_err(info, "unrecognized discard mode value %s",
> +					  args[0].from);
>   				ret =3D -EINVAL;
>   				goto out;
>   			}
> @@ -934,6 +944,8 @@ int btrfs_parse_options(struct btrfs_fs_info *info, =
char *options,
>   				btrfs_set_and_info(info, FREE_SPACE_TREE,
>   						   "enabling free space tree");
>   			} else {
> +				btrfs_err(info, "unrecognized space_cache value %s",
> +					  args[0].from);
>   				ret =3D -EINVAL;
>   				goto out;
>   			}
> @@ -1015,8 +1027,12 @@ int btrfs_parse_options(struct btrfs_fs_info *inf=
o, char *options,
>   			break;
>   		case Opt_check_integrity_print_mask:
>   			ret =3D match_int(&args[0], &intarg);
> -			if (ret)
> +			if (ret) {
> +				btrfs_err(info,
> +				"unrecognized check_integrity_print_mask value %s",
> +					args[0].from);
>   				goto out;
> +			}
>   			info->check_integrity_print_mask =3D intarg;
>   			btrfs_info(info, "check_integrity_print_mask 0x%x",
>   				   info->check_integrity_print_mask);
> @@ -1031,13 +1047,15 @@ int btrfs_parse_options(struct btrfs_fs_info *in=
fo, char *options,
>   			goto out;
>   #endif
>   		case Opt_fatal_errors:
> -			if (strcmp(args[0].from, "panic") =3D=3D 0)
> +			if (strcmp(args[0].from, "panic") =3D=3D 0) {
>   				btrfs_set_opt(info->mount_opt,
>   					      PANIC_ON_FATAL_ERROR);
> -			else if (strcmp(args[0].from, "bug") =3D=3D 0)
> +			} else if (strcmp(args[0].from, "bug") =3D=3D 0) {
>   				btrfs_clear_opt(info->mount_opt,
>   					      PANIC_ON_FATAL_ERROR);
> -			else {
> +			} else {
> +				btrfs_err(info, "unrecognized fatal_errors value %s",
> +					  args[0].from);
>   				ret =3D -EINVAL;
>   				goto out;
>   			}
> @@ -1045,8 +1063,12 @@ int btrfs_parse_options(struct btrfs_fs_info *inf=
o, char *options,
>   		case Opt_commit_interval:
>   			intarg =3D 0;
>   			ret =3D match_int(&args[0], &intarg);
> -			if (ret)
> +			if (ret) {
> +				btrfs_err(info, "unrecognized commit_interval value %s",
> +					  args[0].from);
> +				ret =3D -EINVAL;
>   				goto out;
> +			}
>   			if (intarg =3D=3D 0) {
>   				btrfs_info(info,
>   					   "using default commit interval %us",
> @@ -1060,8 +1082,11 @@ int btrfs_parse_options(struct btrfs_fs_info *inf=
o, char *options,
>   			break;
>   		case Opt_rescue:
>   			ret =3D parse_rescue_options(info, args[0].from);
> -			if (ret < 0)
> +			if (ret < 0) {
> +				btrfs_err(info, "unrecognized rescue value %s",
> +					  args[0].from);
>   				goto out;
> +			}
>   			break;
>   #ifdef CONFIG_BTRFS_DEBUG
>   		case Opt_fragment_all:
