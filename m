Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93355A1698
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiHYQVq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 12:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243025AbiHYQVn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 12:21:43 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A96FAB5146
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 09:21:41 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z72so16380605iof.12
        for <stable@vger.kernel.org>; Thu, 25 Aug 2022 09:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:from:to:cc;
        bh=oNlWthFs8cgnDGfJlBtNitqYjJ3LtCx591pJ256Bmd0=;
        b=abE3Qo3vWkXlQiJxEhh5/tg/aGzz61YnH3/yuSWLe5pOihE79ZYGdkKmLenMCIN5Au
         jtzZ8O6vw2/P4OpOLpMC6gcb18jYvidm0rjj2oV7yjsm56k5imUmNIUaqO6v6pviSb0s
         QStQWZPRr6pATQkXkHqdZdajC1xVUkRfMoTfyx+1PqA1VlvPW5WaweyeCk4wjJ5XOhVj
         S2hAlAkc8wROJZtbkQRuTza2s534lZUqkAaJ/HInU36luL8NE0LWNg/gWW8s2OqBCLkv
         IOjX8G3lSu8Lxqs/qdw1XxztvhV0iBg58OL/vDXCi49kO15FDe/5y4LUPW+RNMh2NBYy
         JazQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=subject:from:cc:to:content-language:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=oNlWthFs8cgnDGfJlBtNitqYjJ3LtCx591pJ256Bmd0=;
        b=CejvTW6Z5n4jHI0BXX1Y77HAE1i07xQE0F13TkPlBrLz/X+amRNY1ezvocflA6CAzl
         xN9yi+woYNBzkv92WMct3g1eR5Cxg9o4gkG8L9h+191z8FgjHac5Qm1AnT01lhOzFcrj
         xkW8xIe5YqOXnjWTZPXHWIKCF0VLzcww6rJYKY5MGuC/PDP86lsdkgSwphsfQg9KgAsb
         rVwOi+YmFP6cw0lT41ijE3jc3Hkm/SdnziDoXIZZ/5dEcEKIGElUPbwGm0oflAkZqRWy
         +Xlyf17sI7hUVst8xp22o9rYvjaityM47ceIx8SJREJLGdJscNzlYFK9PqOpafbWKdyM
         K7xA==
X-Gm-Message-State: ACgBeo0MwM5ZzAXjofHv9zHdILXGw4syuK9dUBH+Nje1LMcdxq72ZTLa
        rXmiWa9FlYWyh61MET1bAKDHsBPje/3zGg==
X-Google-Smtp-Source: AA6agR6DhLjua8X11EJAntbfbOa0QaYSSQCg9fOGSNpsLMOHjxabvDctW57jf4S1eLPAzlbOaQaYTA==
X-Received: by 2002:a02:63ce:0:b0:349:f737:176e with SMTP id j197-20020a0263ce000000b00349f737176emr2215931jac.17.1661444500684;
        Thu, 25 Aug 2022 09:21:40 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x94-20020a0294e7000000b0034a0275ae76sm1118575jah.139.2022.08.25.09.21.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Aug 2022 09:21:39 -0700 (PDT)
Content-Type: multipart/mixed; boundary="------------u6FG4EegzI7WuoVqZchrG0rt"
Message-ID: <a603cfc5-9ba5-20c3-3fec-2c4eec4350f7@kernel.dk>
Date:   Thu, 25 Aug 2022 10:21:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Content-Language: en-US
To:     stable <stable@vger.kernel.org>
Cc:     "song@kernel.org" <song@kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: 5.19 and 5.15 stable patches
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is a multi-part message in MIME format.
--------------u6FG4EegzI7WuoVqZchrG0rt
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

Backport of fix that went into 6.0-rc1 for 5.19-stable and
5.15-stable. Please apply, thanks!

-- 
Jens Axboe

--------------u6FG4EegzI7WuoVqZchrG0rt
Content-Type: text/x-patch; charset=UTF-8;
 name="5.15-0001-io_uring-fix-issue-with-io_write-not-always-undoing-.patch"
Content-Disposition: attachment;
 filename*0="5.15-0001-io_uring-fix-issue-with-io_write-not-always-undoin";
 filename*1="g-.patch"
Content-Transfer-Encoding: base64

RnJvbSA5NTJjN2FjNDlhNTllYjExNTc5MGQxZWM1NTk3NDMwM2M5ZDJmMGZkIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMjUgQXVnIDIwMjIgMTA6MTk6MDggLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogZml4IGlzc3VlIHdpdGggaW9fd3JpdGUoKSBub3QgYWx3YXlzIHVuZG9pbmcK
IHNiX3N0YXJ0X3dyaXRlKCkKCmNvbW1pdCBlMDUzYWFmNGRhNTZjYmYwYWZiMzNhMGZkYTRh
NjIxODhlMmMwNjM3IHVwc3RyZWFtLgoKVGhpcyBpcyBhY3R1YWxseSBhbiBvbGRlciBpc3N1
ZSwgYnV0IHdlIG5ldmVyIHVzZWQgdG8gaGl0IHRoZSAtRUFHQUlOCnBhdGggYmVmb3JlIGhh
dmluZyBkb25lIHNiX3N0YXJ0X3dyaXRlKCkuIE1ha2Ugc3VyZSB0aGF0IHdlIGFsd2F5cyBj
YWxsCmtpb2NiX2VuZF93cml0ZSgpIGlmIHdlIG5lZWQgdG8gcmV0cnkgdGhlIHdyaXRlLCBz
byB0aGF0IHdlIGtlZXAgdGhlCmNhbGxzIHRvIHNiX3N0YXJ0X3dyaXRlKCkgZXRjIGJhbGFu
Y2VkLgoKU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0K
IGZzL2lvX3VyaW5nLmMgfCA3ICsrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA2IGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9mcy9pb191cmluZy5jIGIvZnMv
aW9fdXJpbmcuYwppbmRleCBhNzA5NzQ5NWI0MzMuLmNjZjliZDgwODI3MyAxMDA2NDQKLS0t
IGEvZnMvaW9fdXJpbmcuYworKysgYi9mcy9pb191cmluZy5jCkBAIC0zNzIwLDcgKzM3MjAs
MTIgQEAgc3RhdGljIGludCBpb193cml0ZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWdu
ZWQgaW50IGlzc3VlX2ZsYWdzKQogY29weV9pb3Y6CiAJCWlvdl9pdGVyX3Jlc3RvcmUoaXRl
ciwgc3RhdGUpOwogCQlyZXQgPSBpb19zZXR1cF9hc3luY19ydyhyZXEsIGlvdmVjLCBpbmxp
bmVfdmVjcywgaXRlciwgZmFsc2UpOwotCQlyZXR1cm4gcmV0ID86IC1FQUdBSU47CisJCWlm
ICghcmV0KSB7CisJCQlpZiAoa2lvY2ItPmtpX2ZsYWdzICYgSU9DQl9XUklURSkKKwkJCQlr
aW9jYl9lbmRfd3JpdGUocmVxKTsKKwkJCXJldHVybiAtRUFHQUlOOworCQl9CisJCXJldHVy
biByZXQ7CiAJfQogb3V0X2ZyZWU6CiAJLyogaXQncyByZXBvcnRlZGx5IGZhc3RlciB0aGFu
IGRlbGVnYXRpbmcgdGhlIG51bGwgY2hlY2sgdG8ga2ZyZWUoKSAqLwotLSAKMi4zNS4xCgo=

--------------u6FG4EegzI7WuoVqZchrG0rt
Content-Type: text/x-patch; charset=UTF-8;
 name="5.19-0001-io_uring-fix-issue-with-io_write-not-always-undoing-.patch"
Content-Disposition: attachment;
 filename*0="5.19-0001-io_uring-fix-issue-with-io_write-not-always-undoin";
 filename*1="g-.patch"
Content-Transfer-Encoding: base64

RnJvbSBlNmFiNmM1MjZiYWI2MDIwODY5ZDZkOTdlYjQ2YmVjMDZiNGZkMjg3IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBKZW5zIEF4Ym9lIDxheGJvZUBrZXJuZWwuZGs+CkRh
dGU6IFRodSwgMjUgQXVnIDIwMjIgMTA6MTc6MjUgLTA2MDAKU3ViamVjdDogW1BBVENIXSBp
b191cmluZzogZml4IGlzc3VlIHdpdGggaW9fd3JpdGUoKSBub3QgYWx3YXlzIHVuZG9pbmcK
IHNiX3N0YXJ0X3dyaXRlKCkKCmNvbW1pdCBlMDUzYWFmNGRhNTZjYmYwYWZiMzNhMGZkYTRh
NjIxODhlMmMwNjM3IHVwc3RyZWFtLgoKVGhpcyBpcyBhY3R1YWxseSBhbiBvbGRlciBpc3N1
ZSwgYnV0IHdlIG5ldmVyIHVzZWQgdG8gaGl0IHRoZSAtRUFHQUlOCnBhdGggYmVmb3JlIGhh
dmluZyBkb25lIHNiX3N0YXJ0X3dyaXRlKCkuIE1ha2Ugc3VyZSB0aGF0IHdlIGFsd2F5cyBj
YWxsCmtpb2NiX2VuZF93cml0ZSgpIGlmIHdlIG5lZWQgdG8gcmV0cnkgdGhlIHdyaXRlLCBz
byB0aGF0IHdlIGtlZXAgdGhlCmNhbGxzIHRvIHNiX3N0YXJ0X3dyaXRlKCkgZXRjIGJhbGFu
Y2VkLgoKU2lnbmVkLW9mZi1ieTogSmVucyBBeGJvZSA8YXhib2VAa2VybmVsLmRrPgotLS0K
IGlvX3VyaW5nL2lvX3VyaW5nLmMgfCA3ICsrKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA2IGlu
c2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9pb191cmluZy9pb191
cmluZy5jIGIvaW9fdXJpbmcvaW9fdXJpbmcuYwppbmRleCA2YTY3ZGJmNTE5NWYuLmNkMTU1
YjdlMTM0NiAxMDA2NDQKLS0tIGEvaW9fdXJpbmcvaW9fdXJpbmcuYworKysgYi9pb191cmlu
Zy9pb191cmluZy5jCkBAIC00MzMxLDcgKzQzMzEsMTIgQEAgc3RhdGljIGludCBpb193cml0
ZShzdHJ1Y3QgaW9fa2lvY2IgKnJlcSwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQogY29w
eV9pb3Y6CiAJCWlvdl9pdGVyX3Jlc3RvcmUoJnMtPml0ZXIsICZzLT5pdGVyX3N0YXRlKTsK
IAkJcmV0ID0gaW9fc2V0dXBfYXN5bmNfcncocmVxLCBpb3ZlYywgcywgZmFsc2UpOwotCQly
ZXR1cm4gcmV0ID86IC1FQUdBSU47CisJCWlmICghcmV0KSB7CisJCQlpZiAoa2lvY2ItPmtp
X2ZsYWdzICYgSU9DQl9XUklURSkKKwkJCQlraW9jYl9lbmRfd3JpdGUocmVxKTsKKwkJCXJl
dHVybiAtRUFHQUlOOworCQl9CisJCXJldHVybiByZXQ7CiAJfQogb3V0X2ZyZWU6CiAJLyog
aXQncyByZXBvcnRlZGx5IGZhc3RlciB0aGFuIGRlbGVnYXRpbmcgdGhlIG51bGwgY2hlY2sg
dG8ga2ZyZWUoKSAqLwotLSAKMi4zNS4xCgo=

--------------u6FG4EegzI7WuoVqZchrG0rt--
