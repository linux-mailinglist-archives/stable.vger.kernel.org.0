Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2236DDE3D
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 16:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjDKOkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 10:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbjDKOkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 10:40:35 -0400
X-Greylist: delayed 359 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 07:40:33 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCBC1FC1
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 07:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681223672; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=JVEymPPxKXnD/L0kgcQ9WqfwYylSpLsb2c1Vl5LB4uPSUMja75OGaSnsKFu/r3perM
    iHHZVohgGYpGDVSgzpmuByF4DggyEBxJt09llvKvSWhG0zNe4l3/C/qz5HtqvOkwDOI4
    b4raWHghKRRpWMZvGQ8C2dodR0ulgqPtK1a9rsriPyeXoO3wta5KB+DQ643hy0zVCBXT
    PHWwqMPeNZFI9I85JvYDn/jJfDXmvNphv6Yf6X4dQvGomz5Z9JnJC2eWfJyXNboRu8J7
    T5ZXKJyR7FSVERVsEkNT076l85bPAv6JX1V427vKoYWJnX85wiisZ6B8Zs0/1rGbRsCn
    k81w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681223672;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eCsgvMkIBfwOQUsDQi2fi9vaCufGmroihnnL8bxnDj8=;
    b=Az0XwuBROq+kkO5AUQdVKfl//bivQ6KACC6UwrDcDKqJwCt2v8YHb6CTudx0Mi2fzo
    IbkhVsXUfDetEFiBSM0U+zFmx+tcMPen5zsotQoQpJKfG4QwAe1CWvY+Uv6hVV4pGAQ7
    Tj19aU5b3fU/3HiK2FrMD/J7MjKax3pyKi1WF9vOADuvDO4jennzb4PmqnRcqYCg3lPr
    XLMV8g8CiUu1TyzDEYJUlY2+724mk3sRk4QPAuYO8gtAAsd++RcuvTP/LPcMSyxfG2jG
    vyMtU/MTJjU+ZadHHFe4RL/nh54CldX3NjcsYJm9CG7ptKafILLROOWLf/dncWoDrkoz
    KrLQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681223672;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eCsgvMkIBfwOQUsDQi2fi9vaCufGmroihnnL8bxnDj8=;
    b=ieFlWjnRLQ983Hz0sHEYF8DuYcNOs1MxbBNFQ5llCbnt8FXxjhouLLM2CugBoRGU4v
    ZC4/160NkuC+MMgknaa+EOXe8TxppApKMoXa4jW6B+cdaNvLcIhwQjuaOVLYHh5nJHyn
    ZV0v4XfMSVV/KRxt1vqk57poO+hQLB+xpz9O8/ipoSC1s4gzUqpwa6jvs+AYrdrtTxSh
    iPqSySFPabLQNlg9lACWCGK8n9dBao+MNaFaI7pG8sZNQVYfJXvLWkPkLE83d7HV42+h
    Mo5htXLuIJKxIo8IFGhzKJIchxIFLvPcVWtWwsh8sUPzroPFDMHdTavqScHVvd2Icvj+
    vomA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681223672;
    s=strato-dkim-0003; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eCsgvMkIBfwOQUsDQi2fi9vaCufGmroihnnL8bxnDj8=;
    b=g/QwrVcxV2s78MXVWrhSAP6LHk8R6K6vyZQsG5BvwDBa00r1WRtjcIexAgEhQXCVat
    MdHAbhK5bPkdlX97csBQ==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1q3fUdVyJvGL+KpQ/ths="
Received: from [192.168.44.111]
    by smtp.strato.de (RZmta 49.4.0 AUTH)
    with ESMTPSA id x06214z3BEYVGzA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 11 Apr 2023 16:34:31 +0200 (CEST)
Message-ID: <9dadb8ab-f8d5-7ce3-c110-7bcae1bfb00e@hartkopp.net>
Date:   Tue, 11 Apr 2023 16:34:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: FAILED: patch "[PATCH] can: isotp: isotp_recvmsg(): use
 sock_recv_cmsgs() to get" failed to apply to 5.10-stable tree
To:     gregkh@linuxfoundation.org, mkl@pengutronix.de
Cc:     stable@vger.kernel.org
References: <2023041107-basically-gas-eb2c@gregkh>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <2023041107-basically-gas-eb2c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

this must be a false positive for 5.10 and 5.15.

I can apply the commit 0145462fc802cd447ef5d029758043c7f15b4b1e on 
5.10.y and 5.15.y without problems as the code around

     sock_recv_timestamp(msg, sk, skb);

did not change from 5.10 to 6.3-rc

But 'git am' tells the offset is about ~80 lines.
Could this be the reason for the failure?

Best regards,
Oliver

On 4/11/23 13:36, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> To reproduce the conflict and resubmit, you may use the following commands:
> 
> git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.10.y
> git checkout FETCH_HEAD
> git cherry-pick -x 0145462fc802cd447ef5d029758043c7f15b4b1e
> # <resolve conflicts, build, test, etc.>
> git commit -s
> git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041107-basically-gas-eb2c@gregkh' --subject-prefix 'PATCH 5.10.y' HEAD^..
> 
> Possible dependencies:
> 
> 0145462fc802 ("can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get SOCK_RXQ_OVFL infos")
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
>  From 0145462fc802cd447ef5d029758043c7f15b4b1e Mon Sep 17 00:00:00 2001
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> Date: Thu, 30 Mar 2023 19:02:48 +0200
> Subject: [PATCH] can: isotp: isotp_recvmsg(): use sock_recv_cmsgs() to get
>   SOCK_RXQ_OVFL infos
> 
> isotp.c was still using sock_recv_timestamp() which does not provide
> control messages to detect dropped PDUs in the receive path.
> 
> Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
> Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
> Link: https://lore.kernel.org/all/20230330170248.62342-1-socketcan@hartkopp.net
> Cc: stable@vger.kernel.org
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> diff --git a/net/can/isotp.c b/net/can/isotp.c
> index 9bc344851704..47c2ebad10ed 100644
> --- a/net/can/isotp.c
> +++ b/net/can/isotp.c
> @@ -1120,7 +1120,7 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
>   	if (ret < 0)
>   		goto out_err;
>   
> -	sock_recv_timestamp(msg, sk, skb);
> +	sock_recv_cmsgs(msg, sk, skb);
>   
>   	if (msg->msg_name) {
>   		__sockaddr_check_size(ISOTP_MIN_NAMELEN);
> 
