Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD8266D094
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 21:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbjAPU6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 15:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233626AbjAPU6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 15:58:38 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7E029E28;
        Mon, 16 Jan 2023 12:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
        t=1673902714; bh=Nqkv37q6ANKNw8ayohg/aSuu09RFLmtYoiHFECurdrM=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=crDFxsYOhyq/VBGX3Qn0F3s7dsPk2O9dXcpe4fP7XBojX8l62KVYuxxMKnKAIZrVE
         /tbSIm4eo0YaiZCryBdYdIGjRmdwcHujfMKnDxhBQeQRPWYiPwmBLkkz/SPapBICjt
         KSB5w8+ZBIxzaDOnSZ56gmc8mplBDkNzH+r2S8AAXRetVKMCLt/S1V0WUdbcCmPFeg
         IU6So2n5ONWGlyTgQcfkJjLoziGaOKBqZGsV1yProFfaS51KRcvvd+qABl7V5Q9jjo
         jy0CVpjyy6wYI4jjjXmW2hKDXxwWXsX6XsDVGL78rErx9Oq5dqvdWajsdtpXgH5h5P
         gkk9eoTBB5tbw==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.100.20] ([46.142.35.179]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mlw3X-1orEDZ38Et-00j1Gt; Mon, 16
 Jan 2023 21:58:34 +0100
Message-ID: <8de0d18a-8a53-9fc7-67a3-c953f25e7b75@gmx.de>
Date:   Mon, 16 Jan 2023 21:58:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
From:   Ronald Warsow <rwarsow@gmx.de>
To:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Content-Language: de-DE
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:R+Gw7WD89DV65WyQXLs6zQM3JLG199mBIz1g/X0mlwfBtU/L1RF
 UQO7soUqX+m6Brj05h2FaAVy2rE/TBi+a0ld3qh+PLqgB8ZOW+MENjTPVgxBoKA708W5Ww0
 KNBZS+j48xGGR1TYcdtDbbykftuPaar6Z9SBeENKSGUi+TrlDHFt6viY5W0sfLFEEVFWFtb
 NWtbbvS1f5JbuQWiahIIw==
UI-OutboundReport: notjunk:1;M01:P0:IftALx0q2MQ=;/B2WsGX0vfnu7GxuqQoqVRj/C0B
 4Mesbe9jn/juhnZ3rKsb/7RCHtU0v+lpmw6z2NvuqzSYQG6bbqeCFQ8I+rUeNWea5DXUGJ94x
 MyNFRAZhIiOriy9ol7jM4Ras8Sy+f8kI9NcpPgTXTDFdFnxA+8mMIpljk2q36BUCAVcHK+sRb
 sdIGBc0xR5UWWHoA0vwGtrmS5dQM9jgYXgOcyw+pAQJLsO9L50jQrmtW3tQEvgmKeYJd3vjW3
 aZqn54b7lMtVaXrP6eQ3fOgEVF+dnyhmNv1DPh8tPjTaeGWsXhJwanYpP6CjnAQCY4FsMH/Zc
 5cMqROJKTF3/9Z8s7vj/034/I8TQ2Pc3zBJWGyVmP+LZe/ebNrTWrPh5nX+45yCXRxqTaE5eK
 csEMXtNrox+uZXNfYbgHbcZzxxXs1wwV4PJXSYRbwuurEeENhjw3oeAb13nGJWf7wZzWqC56b
 mKdU2V7K8x/6+TcSvxPOFo8yFpUElJzNe2TSNMN/qDyRgaCws3mR6tZdQXtfuINlJNcaeDr0a
 f+DRyelRZK5gzc3YM4xJBahQhq8b5NoOBlRxz/CMO/XLdDvxcolegj47hiexbNhK3IsRJZMTq
 jATkPgM7j/EnQLT3KSkjBFVmy/R4KzsvU9PONGLxrfyqNVKAwDO+8p2RQ+LvtLQEwI/ip91hK
 9t8GLZ3vEAg3y5wLTvdF1DUC/kzKlJKGsG6hQK97AXylbYX4kOJgW86QQd9JarcxdE7jGjoZ1
 PmZG096B5Mgjy89128iTpEzPIEdf3nUUo1d1ztqv3EH68NkLeRnx5G0ifyC87RQv70GmGdhqa
 EFEjUCVS+h/VfkhhoKvSC3URHiwpbvX2O0oTR6pHMbb6QExWxXjZLckLMpu6ibwVQpcKQIx+s
 4hJC6Uqd0xzVMsGFTYaKgZn4JJP4xfYW9UJfGQ0mlBKFqJseETMRAA5IEBiECWD+dAy4wSxJF
 N/5SMkpmxRwnPzfvtLHhNtbJdaM=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg

6.1.7-rc1

compiles, boots and runs here on x86_64
(Intel i5-11400, Fedora 37)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

