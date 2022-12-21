Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69B8F652D71
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 08:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbiLUHt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Dec 2022 02:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiLUHtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Dec 2022 02:49:25 -0500
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B269B20BDF
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 23:49:22 -0800 (PST)
Received: by mail-lj1-x236.google.com with SMTP id a19so14846846ljk.0
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 23:49:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W4dufR/uux43jl3M8hYAD4DGGD+INaD7xhuItQ1sxqM=;
        b=jyKvA4SA0BID+x3dPHPHetTx8uuU2Ufv5v0ipUrni4s75mswft8Zvab98BtnldYOry
         KN9IADGNThpeJYPKUhhXrVL4uhfYxknL3ZKnjQxxV3zvbXUGGKirQ2zIRTrNbOReyhqy
         q2VltiJkqRFnrwPuMj8hUJ3DcCi1xzQ1HL5fd8unnMhgGWCxEtht5Z6c+riMiiX+jVuC
         Oc7+OtNVFhU4v5zH84NH33TEVCLFhdhywNZwVQMZxDffUB6Ur/+VzKR1Oln3tqRoWd2C
         RogMQ7nrujwdFH4duJWEBflzR8bkd0nwUQShcVVrRiSI7w57XmauDfKG4OCS267QFPsr
         pRkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W4dufR/uux43jl3M8hYAD4DGGD+INaD7xhuItQ1sxqM=;
        b=dumXYPqqUyfAD/OqvuLzeSBN3Aky4saHszc0c6lrZ4G45vKKhoqkWpZV5rk2svm8/v
         HWtdRRBGUjWd6FVWEZdlnInXk6aEXVreZ94YxfQtnFQFyPkkyAyrYo/9ubPJHwKWEpuu
         RXGegB0qA6WMxcGAuWvPdQE+4jTshI9GqYx7h37H0xr4xvhbY7HZgrSru+w67srA2MGU
         novzqu92da/GT80CRmac3dBlctEHhZE+Ir+6augsEg/q1gFuOKNuWXxJhF9mDKTn2JM4
         zVz6PGCdbcoHcuJ5g/sGlXwwJCC/WRZvCbRSggNcfTon2allS8Md4byVHPSW6f+C96jo
         0AQQ==
X-Gm-Message-State: AFqh2krrUUGX5CmXxDg8W3MycGxou/ihCCAhhGgtMfzVA68DL6WFHvjf
        ANPL3B1iUyXMf6o+NMaTTWL84Q==
X-Google-Smtp-Source: AMrXdXuL8CIiSpj3KjFKlORDGshD2jdfuqOiS5wOIen9p5A4YK/CKXwv+XuGmNs1gZhtcEvzmJqFzQ==
X-Received: by 2002:a2e:8503:0:b0:279:cd84:1f26 with SMTP id j3-20020a2e8503000000b00279cd841f26mr1325536lji.13.1671608961015;
        Tue, 20 Dec 2022 23:49:21 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m8-20020ac24288000000b004a2c3fd32edsm1762548lfh.144.2022.12.20.23.49.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Dec 2022 23:49:20 -0800 (PST)
Message-ID: <bdddd72f-a118-ff43-c53f-5ffd724fbd55@linaro.org>
Date:   Wed, 21 Dec 2022 08:49:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] tty: serial: qcom-geni-serial: fix slab-out-of-bounds on
 RX FIFO buffer
To:     Jiri Slaby <jirislaby@kernel.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Satya Priya <quic_c_skakit@quicinc.com>,
        linux-arm-msm@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20221220161530.2098299-1-krzysztof.kozlowski@linaro.org>
 <b21a17c7-df9c-ce20-f986-8f093a33278c@kernel.org>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <b21a17c7-df9c-ce20-f986-8f093a33278c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/12/2022 07:43, Jiri Slaby wrote:
> On 20. 12. 22, 17:15, Krzysztof Kozlowski wrote:
>> Driver's probe allocates memory for RX FIFO (port->rx_fifo) based on
>> default RX FIFO depth, e.g. 16.  Later during serial startup the
>> qcom_geni_serial_port_setup() updates the RX FIFO depth
>> (port->rx_fifo_depth) to match real device capabilities, e.g. to 32.
> ...
>> If the RX FIFO depth changes after probe, be sure to resize the buffer.
>>
>> Fixes: f9d690b6ece7 ("tty: serial: qcom_geni_serial: Allocate port->rx_fifo buffer in probe")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
> 
> This patch LGTM, I only wonder:
> 
>> --- a/drivers/tty/serial/qcom_geni_serial.c
>> +++ b/drivers/tty/serial/qcom_geni_serial.c
>> @@ -864,9 +864,10 @@ static irqreturn_t qcom_geni_serial_isr(int isr, void *dev)
>>   	return IRQ_HANDLED;
>>   }
>>   
>> -static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
>> +static int get_tx_fifo_size(struct qcom_geni_serial_port *port)
> 
> ... why is this function dubbed get_tx_fifo_size(), provided it handles 
> rx fifo too? And it does not "get" the tx fifo size. In fact, the 
> function sets that :).

I reads the FIFO sizes from the device registers, so I guess that was
behind the naming.

> 
>>   {
>>   	struct uart_port *uport;
>> +	u32 old_rx_fifo_depth = port->rx_fifo_depth;
>>   
>>   	uport = &port->uport;
>>   	port->tx_fifo_depth = geni_se_get_tx_fifo_depth(&port->se);
>> @@ -874,6 +875,16 @@ static void get_tx_fifo_size(struct qcom_geni_serial_port *port)
>>   	port->rx_fifo_depth = geni_se_get_rx_fifo_depth(&port->se);
>>   	uport->fifosize =
>>   		(port->tx_fifo_depth * port->tx_fifo_width) / BITS_PER_BYTE;
>> +
>> +	if (port->rx_fifo && (old_rx_fifo_depth != port->rx_fifo_depth) && port->rx_fifo_depth) {
>> +		port->rx_fifo = devm_krealloc(uport->dev, port->rx_fifo,
>> +					      port->rx_fifo_depth * sizeof(u32),
>> +					      GFP_KERNEL);
> 
> And now it even allocates memory.
> 
> So more appropriate name should be setup_fifos() or similar.

Sure, I'll rename it and keep your Rb tag.

> 

Best regards,
Krzysztof

